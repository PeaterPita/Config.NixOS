(import ../../utils/mkService.nix) {
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

      sops = {
        secrets = {
          "paperless/admin_pass" = { };
          "paperless/oidc_secret" = { };
          "paperless/secret_key" = { };
        };
        templates = {
          "paperless/oidc.env" = {
            content = ''
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
          };
        };
      };

      services.paperless = {
        enable = true;
        inherit (cfg) port;
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
