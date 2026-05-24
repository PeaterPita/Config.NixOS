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

    sops.secrets."filebrowser-quantum/oidc_secret" = {
      owner = "filebrowser-quantum";
      sopsFile = ../../../secrets/services.yaml;
    };

    systemd.tmpfiles.rules = [
      "d /mnt/files 0755 filebrowser-quantum filebrowser-quantum -"
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

        LoadCredential = [
          "admin-pass:${config.sops.secrets."filebrowser-quantum/admin-pass".path}"
          "oidc_secret:${config.sops.secrets."filebrowser-quantum/oidc_secret".path}"
        ];

        ProtectHome = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
        NoNewPrivileges = true;
        ReadWritePaths = [
          cfg.dataDir
          "/mnt/files"
        ];
      };

      preStart = ''
        cp --no-preserve=mode ${configFile} ${cfg.dataDir}/config.yaml
        ${pkgs.replace-secret}/bin/replace-secret '@admin-pass@' "$CREDENTIALS_DIRECTORY/admin-pass" ${cfg.dataDir}/config.yaml
        ${pkgs.replace-secret}/bin/replace-secret '@oidc_secret@' "$CREDENTIALS_DIRECTORY/oidc_secret" ${cfg.dataDir}/config.yaml
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
          "group:admin"
          "group:files"
        ];
      }
    ];

    homelab.services.authelia.oidc = [
      {
        client_id = "filebrowser-quantum";
        client_name = "filebrowser-quantum";
        client_secret = "$pbkdf2-sha512$310000$M0aB6kr6zH6rGGXQjH1Zhg$CsivwUa/1vCxSR9HvSa9Q2rX.vEHgJrcCZdtOCjv/ng2MOi95DqM32JBFFdoBZqzJps5Z7soNFnF9.OqRALfIQ";
        public = false;
        authorization_policy = "one_factor";
        redirect_uris = [ "https://${cfg.domain}/api/auth/oidc/callback" ];
        scopes = [
          "openid"
          "profile"
          "email"
          "groups"
        ];
        token_endpoint_auth_method = "client_secret_basic";
      }
    ];

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    homelab.services.filebrowser-quantum = {
      settings = {
        server = {
          port = cfg.port;
          sources = [
            {
              path = "/mnt/files";
              name = "files";
              config = {
                defaultEnabled = true;
                # defaultUserScope = "/";
                createUserDir = true;
              };
            }
          ];
        };

        userDefaults = {
          permissions = {
            modify = true;
            share = true;
            delete = true;
            create = true;
          };
          preview.popup = false;
        };

        auth = {
          adminUsername = "admin";
          adminPassword = "@admin-pass@";
          methods = {
            password = {
              enabled = true;
              signup = false;
            };

            oidc = {
              enabled = true;
              clientId = "filebrowser-quantum";
              clientSecret = "@oidc_secret@";
              issuerUrl = "https://auth.${vars.baseDomain}";
              scopes = "openid email profile groups";
              userIdentifier = "preferred_username";
              adminGroup = "admin";
              createUser = true;
              groupsClaim = "groups";
            };
          };
        };

        integrations.media.ffmpegPath = "${pkgs.ffmpeg-full}/bin";

        frontend = {
          name = "QuantumFiles";
        };
      };

    };

  };
}
