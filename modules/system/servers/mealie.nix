(import ../../../utils/mkService.nix) {
  name = "mealie";
  port = 9004;
  domain = "meals";

  routing = {
    protected = false;
    healthPath = "/api/app/about";
  };

  homepage = {
    group = "Apps";
    description = "Recipes & Meals";
  };

  extraConfig =
    {
      config,
      cfg,
      vars,
      ...
    }:
    {

      homelab.services.authelia.oidc = [
        {
          client_id = "mealie";
          client_name = "mealie";
          client_secret = "$pbkdf2-sha512$310000$BdOjxueVb7q4XcGk9FzbIQ$zvunGtuGX9DRJAd5sPbOQzn3x/b4lVrKro3IkLU9u1kxsecS7lx0gARSd7Qdlif2NDhqD77ioCpNSNkgAMAR0w";
          public = false;
          authorization_policy = "one_factor";
          grant_types = [ "authorization_code" ];
          redirect_uris = [
            "https://${cfg.domain}.${vars.baseDomain}/login"
            "http://${cfg.domain}.${vars.baseDomain}/login"
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

      sops.secrets."mealie/oidc_secret" = {
        sopsFile = ../../../secrets/services.yaml;
      };

      sops.templates."mealie.env".content = ''
        OIDC_CLIENT_SECRET=${config.sops.placeholder."mealie/oidc_secret"}
      '';

      homelab.services.backup = {
        paths = [ "/var/lib/mealie/recipes" ];
        dbFiles.mealie = "/var/lib/mealie/mealie.db";
      };

      services.mealie = {
        enable = true;
        port = cfg.port;
        settings = {
          TZ = "GMT";
          BASE_URL = "https://${cfg.domain}.${vars.baseDomain}";

          OIDC_AUTH_ENABLED = "true";
          OIDC_CONFIGURATION_URL = "https://auth.${vars.baseDomain}/.well-known/openid-configuration";

          OIDC_CLIENT_ID = "mealie";

          OIDC_AUTO_REDIRECT = "false";

          OIDC_GROUPS_CLAIM = "groups";
          OIDC_ADMIN_GROUP = "admin";
          OIDC_USER_GROUP = "meals";

          ALLOW_SIGNUP = "false";
          ALLOW_PASSWORD_LOGIN = "false";

          OIDC_PROVIDER_NAME = "Authelia";
          OIDC_REMEMBER_ME = "true";
          OIDC_SIGNING_ALGORITHM = "RS256";
        };
        credentialsFile = config.sops.templates."mealie.env".path;
      };
    };

}
