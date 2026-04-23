{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.mealie;
  vars = config.homelab;
in

{
  options.homelab.services.mealie = {
    enable = lib.mkEnableOption "Enable the Mealie recipe storage and sharing platform";
    port = lib.mkOption { default = 9004; };
    domain = lib.mkOption { default = "meals.${vars.baseDomain}"; };
  };

  config = lib.mkIf cfg.enable {

    homelab.services.homepage.groups."Media" = [
      {
        Mealie = {
          icon = "mealie.png";
          href = "http://${cfg.domain}";
          description = "Recipes & Meals";
          ping = "http://127.0.0.1:${builtins.toString cfg.port}";
        };
      }
    ];

    homelab.services.authelia.oidc = [
      {
        client_id = "mealie";
        client_name = "mealie";
        client_secret = "$pbkdf2-sha512$310000$BdOjxueVb7q4XcGk9FzbIQ$zvunGtuGX9DRJAd5sPbOQzn3x/b4lVrKro3IkLU9u1kxsecS7lx0gARSd7Qdlif2NDhqD77ioCpNSNkgAMAR0w";
        public = false;
        authorization_policy = "one_factor";
        grant_types = [ "authorization_code" ];
        redirect_uris = [
          "https://${cfg.domain}/login"
          "http://${cfg.domain}/login"
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

    # services.postgresql = {
    #   enable = true;
    #   ensureDatabases = [ "mealie" ];
    #   ensureUsers = [
    #     {
    #       name = "mealie";
    #       ensureDBOwnership = true;
    #     }
    #   ];
    # };

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.mealie = {
      enable = true;
      port = cfg.port;
      settings = {
        # DB_ENGINE = "postgres";
        # POSTGRES_SERVER = "127.0.0.1";
        # POSTGRES_USER = "mealie";
        # POSTGRES_DB = "mealie";

        TZ = "GMT";
        BASE_URL = "https://${cfg.domain}";

        OIDC_AUTH_ENABLED = "true";
        OIDC_CONFIGURATION_URL = "https://auth.${vars.baseDomain}/.well-known/openid-configuration";

        OIDC_CLIENT_ID = "mealie";

        OIDC_AUTO_REDIRECT = "false";

        OIDC_GROUPS_CLIAM = "groups";
        OIDC_ADMIN_GROUP = "admin";
        OIDC_USER_GROUP = "family";

        OIDC_PROVIDER_NAME = "Authelia";
        OIDC_REMEMBER_ME = "true";
        OIDC_SIGNING_ALGORITHM = "RS256";
      };
      credentialsFile = config.sops.templates."mealie.env".path;
    };
  };

}
