{
  config,
  lib,
  pkgs,
  ...
}:

let
  vars = config.homelab;
  cfg = vars.services.filebrowser-quantum;

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" cfg.settings;
in

{
  options.homelab.services.filebrowser-quantum = {
    enable = lib.mkEnableOption "Enable filebrowser-quantum custom module";
    port = lib.mkOption { default = 9007; };
    domain = lib.mkOption { default = "files.${vars.baseDomain}"; };

    package = lib.mkPackageOption pkgs.unstable "filebrowser-quantum" { };
    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };

    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/filebrowser-quantum";
    };
  };

  config = lib.mkIf cfg.enable {

    sops.secrets."filebrowser-quantum/admin-pass" = {
      owner = "filebrowser-quantum";
      sopsFile = ../../../secrets/services.yaml;
    };

    systemd.tmpfiles.rules = [
      "d /srv/files 0755 filebrowser-quantum filebrowser-quantum -"
    ];
    systemd.services.filebrowser-quantum = {
      description = "Filebrowser Quantum";

      path = [ pkgs.ffmpeg-full ];

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} -c ${cfg.dataDir}/config.yaml";
        WorkingDirectory = cfg.dataDir;
        StateDirectory = "filebrowser-quantum";
        User = "filebrowser-quantum";
        Group = "filebrowser-quantum";
        Restart = "on-failure";

        LoadCredential = [ "admin-pass:${config.sops.secrets."filebrowser-quantum/admin-pass".path}" ];

        ProtectHome = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
        NoNewPrivileges = true;
        ReadWritePaths = [
          "/var/lib/filebrowser-quantum"
          "/srv/files"
          cfg.dataDir
        ];
      };

      preStart = ''
        cp --no-preserve=mode ${configFile} ${cfg.dataDir}/config.yaml
        ${pkgs.replace-secret}/bin/replace-secret '@admin-pass@' "$CREDENTIALS_DIRECTORY/admin-pass" ${cfg.dataDir}/config.yaml
      '';

    };

    users.users.filebrowser-quantum = {
      isSystemUser = true;
      group = "filebrowser-quantum";
    };

    users.groups.filebrowser-quantum = { };

    homelab.services.homepage.groups."Apps" = [
      {
        Filebrowser-quantum = {
          icon = "filebrowser-quantum.png";
          href = "http://${cfg.domain}";
          description = "File Sharing";
          ping = "http://127.0.0.1:${builtins.toString cfg.port}";
        };
      }
    ];

    homelab.services.authelia.rules = [

      {
        domain = cfg.domain;
        resources = [ "^/public/.*$" ];
        policy = "bypass";
      }

      {
        domain = [
          cfg.domain
        ];
        policy = "one_factor";
        subject = [
          "group:family"
          "group:admin"
        ];
      }
    ];

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
