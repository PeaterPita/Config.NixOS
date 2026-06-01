{
  config,
  lib,
  pkgs,
  ...
}:

let
  vars = config.homelab;
  cfg = vars.services.immich;
  mediaLoc = "/mnt/immich/";
in

{
  options.homelab.services.immich = {
    enable = lib.mkEnableOption "Enable Immich, replacing google photos";
    port = lib.mkOption { default = 2283; };
    domain = lib.mkOption { default = "photos.${vars.baseDomain}"; };
  };

  config = lib.mkIf cfg.enable {

    homelab.services.homepage.disks = [ "/mnt/immich/" ];

    systemd.tmpfiles.rules = [
      "d ${mediaLoc} 0775 root immich - -"
    ];

    homelab.services.homepage.groups."Apps" = [
      {
        Immich = {
          icon = "immich.png";
          href = "https://${cfg.domain}";
          description = "Photo Storage & Backup";
          ping = "https://${cfg.domain}";
        };
      }
    ];

    homelab.services.authelia.oidc = [
      {
        client_id = "immich";
        client_name = "immich";
        client_secret = "$pbkdf2-sha512$310000$l7sDDGfpmPLYHGAAo4tyzw$q1Qq84ZMp4ImubtnlK6uyhaDnU8r4EwQCeWvMkVUq4Ox1oeS6xyoRm7ZpP1krPumD5LXDocwU/oPkl.d1EGRCA";
        public = false;
        authorization_policy = "photo_access";
        # authorization_policy = "two_factor";
        grant_types = [ "authorization_code" ];
        redirect_uris = [
          "https://${cfg.domain}/auth/login"
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

    homelab.services.authelia.policies.photo_access = {
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

    sops.secrets."immich/oidc_secret" = {
      sopsFile = ../../../secrets/services.yaml;
    };
    services.immich = {
      enable = true;
      port = cfg.port;
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
