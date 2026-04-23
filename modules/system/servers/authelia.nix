{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.authelia;
  vars = config.homelab;
in

{
  options.homelab.services.authelia = {
    enable = lib.mkEnableOption "Enable authelia";
    port = lib.mkOption { default = 9091; };

    rules = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {

    sops.secrets."authelia/jwt_secret" = {
      sopsFile = ../../../secrets/services.yaml;
      mode = "0444";
    };
    sops.secrets."authelia/storage_key" = {
      sopsFile = ../../../secrets/services.yaml;
      mode = "0444";
    };
    sops.secrets."authelia/session_secret" = {
      sopsFile = ../../../secrets/services.yaml;
      mode = "0444";
    };
    sops.secrets."authelia/ldap_password" = {
      sopsFile = ../../../secrets/services.yaml;
      mode = "0444";
    };

    homelab.services.homepage.groups."Infrastructure" = [
      {
        authelia = {
          icon = "authelia.png";
          href = "http://auth.${vars.baseDomain}";
          description = "User Authentication";
        };
      }
    ];

    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];

    services.authelia.instances.main = {
      enable = true;

      secrets = {
        jwtSecretFile = config.sops.secrets."authelia/jwt_secret".path;
        storageEncryptionKeyFile = config.sops.secrets."authelia/storage_key".path;
        sessionSecretFile = config.sops.secrets."authelia/session_secret".path;
      };

      environmentVariables = {
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE =
          config.sops.secrets."authelia/ldap_password".path;
      };
      settings = {

        theme = "dark";
        default_2fa_method = "totp";

        log.format = "json";

        totp.issuer = "${vars.baseDomain}";

        authentication_backend.ldap = {
          implementation = "lldap";

          address = "ldap://127.0.0.1:${toString config.services.lldap.settings.ldap_port}";
          base_dn = config.services.lldap.settings.ldap_base_dn;

          user = "uid=authelia,ou=people,${config.services.lldap.settings.ldap_base_dn}";

          users_filter = "(&(|({username_attribute}={input})({mail_attribute}={input}))(objectClass=person))";

          groups_filter = "(member={dn})";
        };

        session = {
          cookies = [
            {
              domain = "${vars.baseDomain}";
              authelia_url = "https://auth.${vars.baseDomain}";
              default_redirection_url = "https://${vars.baseDomain}";
            }
          ];
        };

        storage = {
          local = {
            path = "/var/lib/authelia-main/db.sqlite3";
          };
        };

        notifier = {
          filesystem = {
            filename = "/var/lib/authelia-main/notifications.txt";
          };
        };

        access_control = {
          default_policy = "deny";
          rules = [
            {

              domain = "auth.${vars.baseDomain}";
              policy = "bypass";

            }

            {
              domain = [
                "traefik.${vars.baseDomain}"
                "adguard.${vars.baseDomain}"
              ];
              policy = "two_factor";
              subject = [ "group:admin" ];
            }
          ]
          ++ cfg.rules;

          # rules = [
          #
          #
          #   {
          #     domain = "files.${vars.baseDomain}";
          #     policy = "one_factor";
          #     subject = [
          #       "group:friends"
          #       "group:family"
          #       "group:admin"
          #     ];
          #   }
          #
          #
          # ];
        };

        server.address = "tcp://0.0.0.0:${toString cfg.port}";

      };
    };
  };

}
