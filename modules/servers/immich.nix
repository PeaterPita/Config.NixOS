(import ../../utils/mkService.nix) {
  name = "immich";
  port = 2283;
  domain = "photos";

  routing = {
    protected = false;
    healthPath = "/api/server/ping";
  };

  homepage = {
    group = "Apps";
    description = "Photo Storage & Backup";
  };

  extraConfig =
    {
      cfg,
      vars,
      config,
      ...
    }:

    let
      mediaLoc = "/mnt/immich/";
    in

    {
      systemd.tmpfiles.rules = [
        "d ${mediaLoc} 0775 root immich - -"
      ];

      homelab.services = {

        homepage.disks = [ mediaLoc ];
        backup.paths = [ "${mediaLoc}/upload" ];

        authelia.oidc = [
          {
            client_id = "immich";
            client_name = "immich";
            client_secret = "$pbkdf2-sha512$310000$l7sDDGfpmPLYHGAAo4tyzw$q1Qq84ZMp4ImubtnlK6uyhaDnU8r4EwQCeWvMkVUq4Ox1oeS6xyoRm7ZpP1krPumD5LXDocwU/oPkl.d1EGRCA";
            public = false;
            authorization_policy = "photo_access";
            grant_types = [ "authorization_code" ];
            redirect_uris = [
              "https://${cfg.domain}.${vars.baseDomain}/auth/login"
              "app.immich:///oauth-callback"
            ];
            scopes = [
              "openid"
              "profile"
              "email"
              "groups"
            ];
            token_endpoint_auth_method = "client_secret_post";
          }
        ];

        authelia.policies.photo_access = {
          default_policy = "deny";
          rules = [
            {
              policy = "two_factor";
              subject = [
                "group:photos"
                "group:admin"
              ];
            }
          ];
        };
      };

      sops.secrets."immich/oidc_secret" = { };
      services.immich = {
        enable = true;
        inherit (cfg) port;
        host = "0.0.0.0";
        openFirewall = true;
        database = {
          enable = true;
          createDB = true;
        };
        mediaLocation = mediaLoc;
        settings = {
          passwordLogin.enabled = true;
          oauth = {
            buttonText = "Login With Authelia";
            issuerUrl = "https://auth.${vars.baseDomain}";
            clientId = "immich";
            clientSecret._secret = config.sops.secrets."immich/oidc_secret".path;
            # defaultStorageQuota = "";
            enabled = true;
            roleClaim = "groups";
            tokenEndpointAuthMethod = "client_secret_post";
          };
        };
      };
    };
}
