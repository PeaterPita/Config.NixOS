(import ../../utils/mkService.nix) {
  name = "authelia";
  port = 9091;
  domain = "auth";
  extraOptions =
    { lib, ... }:
    {
      rules = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
      };

      oidc = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
      };

      policies = lib.mkOption {
        type = lib.types.attrsOf lib.types.attrs;
        default = { };
      };
    };

  homepage = {
    group = "Infrastructure";
    description = "User Authentication";
  };

  extraConfig =
    {
      config,
      vars,
      cfg,
      ...
    }:
    {

      sops.secrets = builtins.listToAttrs (
        map
          (secret: {
            name = secret;
            value = {
              mode = "0444";
              owner = "authelia-main";
            };

          })
          [
            "authelia/jwt_secret"
            "authelia/storage_key"
            "authelia/session_secret"
            "authelia/ldap_password"
            "authelia/hmac_secret"
            "authelia/issuer_key"
          ]
      );

      services.authelia.instances.main = {
        enable = true;

        secrets = {
          jwtSecretFile = config.sops.secrets."authelia/jwt_secret".path;
          storageEncryptionKeyFile = config.sops.secrets."authelia/storage_key".path;
          sessionSecretFile = config.sops.secrets."authelia/session_secret".path;

          oidcHmacSecretFile = config.sops.secrets."authelia/hmac_secret".path;
          oidcIssuerPrivateKeyFile = config.sops.secrets."authelia/issuer_key".path;
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

          # identity_validation.elevated_session = {
          #   require_second_factor = false;
          #   skip_second_factor = true;
          # };

          authentication_backend.ldap = {
            implementation = "lldap";

            address = "ldap://127.0.0.1:${toString config.services.lldap.settings.ldap_port}";
            base_dn = config.services.lldap.settings.ldap_base_dn;

            user = "uid=authelia,ou=people,${config.services.lldap.settings.ldap_base_dn}";

            users_filter = "(&(|({username_attribute}={input})({mail_attribute}={input}))(objectClass=person))";

            groups_filter = "(member={dn})";
          };

          identity_providers.oidc = {
            clients = cfg.oidc;
            authorization_policies = cfg.policies;

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
                domain = [ "traefik.${vars.baseDomain}" ];
                policy = "two_factor";
                subject = [ "group:admin" ];
              }

              {
                domain = [ "adguard.${vars.baseDomain}" ];
                policy = "one_factor";
                subject = [ "group:admin" ];
              }

            ]
            ++ cfg.rules;

          };

          server.address = "tcp://0.0.0.0:${toString cfg.port}";
          server.buffers.read = 8192;

        };
      };

    };

}
