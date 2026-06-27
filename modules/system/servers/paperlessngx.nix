(import ../../../utils/mkService.nix) {
  name = "paperless-ngx";
  port = 28981;
  domain = "documents";

  routing = {
    protected = false;
    healthPath = "/";
  };

  homepage = {
    group = "Apps";
    description = "Document Storage";
  };

  extraConfig =
    {
      config,
      cfg,
      vars,
      ...
    }:
    {

      sops.secrets."paperless/admin_pass" = {
        sopsFile = ../../../secrets/services.yaml;
      };

      sops.secrets."paperless/secret_key" = {
        sopsFile = ../../../secrets/services.yaml;
      };

      sops.secrets."paperless/oidc_secret" = {
        sopsFile = ../../../secrets/services.yaml;
      };

      homelab.services.backup.paths = [ "/var/lib/paperless" ];

      homelab.services.authelia.oidc = [
        {
          client_id = "paperless";
          client_name = "paperless";
          client_secret = "$pbkdf2-sha512$310000$DpP8ZpIAxvvJXvXccNakjQ$x1gmoS82zDDjVVUjkrlXmFjHsripeEgcOKg5sseb6iKi/3cqth8o3OWbS4n6x0PYK1Q/JnPw70YFFmlMKgKUWg";
          public = false;
          authorization_policy = "document_access";
          grant_types = [ "authorization_code" ];
          redirect_uris = [
            "https://${cfg.domain}.${vars.baseDomain}/accounts/oidc/authelia/login/callback/"
          ];
          scopes = [
            "openid"
            "profile"
            "email"
            "groups"
          ];
          token_endpoint_auth_method = "client_secret_basic";
        }
      ];

      homelab.services.authelia.policies.document_access = {
        default_policy = "deny";
        rules = [
          {
            policy = "two_factor";
            subject = [
              "group:documents"
              "group:admin"
            ];
          }
        ];
      };

      sops.templates."paperless/oidc.env".content = ''
            PAPERLESS_SOCIALACCOUNT_PROVIDERS='{
                "openid_connect":{
                    "SCOPE":["openid","profile","email","groups"],
                    "APPS":[{
                        "provider_id":"authelia",
                        "name":"Authelia",
                        "client_id":"paperless",
                        "secret":"${config.sops.placeholder."paperless/oidc_secret"}",
                        "settings":{
                            "server_url":"https://auth.${vars.baseDomain}/.well-known/openid-configuration",
                            "token_auth_method":"client_secret_basic"
                        }
                    }
                ]
            }
        }'
      '';

      services.paperless = {
        enable = true;
        port = cfg.port;
        address = "0.0.0.0";
        domain = "${cfg.domain}.${vars.baseDomain}";

        passwordFile = config.sops.secrets."paperless/admin_pass".path;

        environmentFile = config.sops.templates."paperless/oidc.env".path;
        settings = {
          PAPERLESS_SECRET_KEY = config.sops.secrets."paperless/secret_key".path;
          PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
          PAPERLESS_SOCIAL_AUTO_SIGNUP = "true";
          PAPERLESS_SOCIAL_ACCOUNT_DEFAULT_GROUPS = "default";
        };
      };
    };
}
