(import ../../../utils/mkService.nix) {
  name = "wakapi";
  port = 7598;

  routing = {
    protected = false;
    healthPath = "/api/health";
  };

  homepage = {
    group = "Apps";
    description = "Code Stats";
  };

  extraConfig =
    {
      config,
      cfg,
      vars,
      pkgs,
      ...
    }:
    {

      sops.secrets."wakapi/oidc_secret" = {
        sopsFile = ../../../secrets/services.yaml;
      };

      sops.secrets."wakapi/pass_salt" = {
        sopsFile = ../../../secrets/services.yaml;
      };

      sops.templates."wakapi.env".content = ''
        WAKAPI_OIDC_PROVIDERS_0_CLIENT_SECRET=${config.sops.placeholder."wakapi/oidc_secret"}
        WAKAPI_PASSWORD_SALT=${config.sops.placeholder."wakapi/pass_salt"}
      '';

      homelab.services.authelia.oidc = [
        {
          client_id = "wakapi";
          client_name = "wakapi";
          client_secret = "$pbkdf2-sha512$310000$K8uMkb1O1kaKwhRfTeMWIg$QzFbTfstFi6I00rPYW4ueL9UemGWe1Ny9zNwPAcn0YJRAGGMx3ZGv5s22Rsr76bUJdwoLfKZfJqaEKoKkdOapw";
          public = false;
          authorization_policy = "wak_access";
          grant_types = [ "authorization_code" ];
          redirect_uris = [
            "https://${cfg.domain}.${vars.baseDomain}/oidc/authelia/callback"
          ];
          scopes = [
            "openid"
            "profile"
            "email"
          ];
          token_endpoint_auth_method = "client_secret_post";
        }
      ];

      homelab.services.authelia.policies.wak_access = {
        default_policy = "deny";
        rules = [
          {
            policy = "one_factor";
            subject = [
              "group:wakapi"
              "group:admin"
            ];
          }
        ];
      };

      services.wakapi = {
        enable = true;
        package = pkgs.unstable.wakapi;
        environmentFiles = [ config.sops.templates."wakapi.env".path ];
        settings = {
          server = {
            listen_ipv4 = "0.0.0.0";
            listen_ipv6 = "-";
            public_url = "https://${cfg.domain}.${vars.baseDomain}";
            port = cfg.port;

          };
          security = {
            allow_signup = false;
            oidc_allow_signup = true;
            disable_local_auth = true;
            signup_captacha = true;
            invite_codes = false;
            disable_frontpage = true;
            oidc = [
              {
                name = "authelia";
                client_id = "wakapi";
                endpoint = "https://auth.${vars.baseDomain}";
              }
            ];
          };
        };
      };

    };
}
