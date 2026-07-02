(import ../../utils/mkService.nix) {
  name = "filebrowser-quantum";
  port = 9007;
  domain = "files";

  extraOptions =
    { lib, pkgs }:
    {
      package = lib.mkPackageOption pkgs.unstable "filebrowser-quantum" { };
      settings = lib.mkOption {
        inherit ((pkgs.formats.yaml { })) type;
        default = { };
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/filebrowser-quantum";
      };

    };

  routing = {
    protected = true;
    healthPath = "/health";
  };

  homepage = {
    group = "Apps";
    description = "File Sharing";
  };

  extraConfig =
    {
      lib,
      pkgs,
      config,
      cfg,
      vars,
      ...
    }:
    let
      settingsFormat = pkgs.formats.yaml { };
      configFile = settingsFormat.generate "config.yaml" cfg.settings;

      mediaDir = "/mnt/files";

    in
    {

      sops.secrets."filebrowser-quantum/admin-pass".owner = "filebrowser-quantum";

      sops.secrets."filebrowser-quantum/oidc_secret".owner = "filebrowser-quantum";

      systemd.tmpfiles.rules = [
        "d ${mediaDir} 0755 filebrowser-quantum filebrowser-quantum -"
      ];
      systemd.services.filebrowser-quantum = {
        description = "Filebrowser Quantum";

        path = [ pkgs.ffmpeg-full ];

        after = [
          "network-online.target"
          "authelia-main.service"
        ];
        wants = [ "network-online.target" ];
        requires = [ "authelia-main.service" ];
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
            mediaDir
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

      homelab.services = {
        backup.paths = [ mediaDir ];

        authelia.rules = [

          {
            domain = "${cfg.domain}.${vars.baseDomain}";
            resources = [ "^/public/.*$" ];
            policy = "bypass";
          }

          {
            domain = [
              "${cfg.domain}.${vars.baseDomain}"
            ];
            policy = "one_factor";
            subject = [
              "group:admin"
              "group:files"
            ];
          }
        ];

        authelia.oidc = [
          {
            client_id = "filebrowser-quantum";
            client_name = "filebrowser-quantum";
            client_secret = "$pbkdf2-sha512$310000$M0aB6kr6zH6rGGXQjH1Zhg$CsivwUa/1vCxSR9HvSa9Q2rX.vEHgJrcCZdtOCjv/ng2MOi95DqM32JBFFdoBZqzJps5Z7soNFnF9.OqRALfIQ";
            public = false;
            authorization_policy = "one_factor";
            redirect_uris = [ "https://${cfg.domain}.${vars.baseDomain}/api/auth/oidc/callback" ];
            scopes = [
              "openid"
              "profile"
              "email"
              "groups"
            ];
            token_endpoint_auth_method = "client_secret_basic";
          }
        ];
      };

      homelab.services.filebrowser-quantum = {
        settings = {
          server = {
            inherit (cfg) port;
            sources = [
              {
                path = mediaDir;
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
