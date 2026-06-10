(import ../../../utils/mkService.nix) {
  name = "kavita";
  port = 5000;
  domain = "books";

  routing = {
    protected = false;
    healthPath = "/api/health";
  };

  homepage = {
    group = "Apps";
    description = "Book reading";
  };

  extraConfig =
    {
      pkgs,
      vars,
      config,
      cfg,
      lib,
      ...
    }:
    {
      homelab.services.homepage.disks = [ "/mnt/media/books" ];

      systemd.tmpfiles.rules = [
        "d /mnt/media/books 2775 root media - - "
      ];

      users.users.kavita.extraGroups = [ "media" ];
      sops.secrets."kavita/token_key" = {
        sopsFile = ../../../secrets/services.yaml;
        owner = "kavita";
        group = "kavita";
        mode = "0400";
      };

      sops.secrets."kavita/oidc_secret" = {
        sopsFile = ../../../secrets/services.yaml;
        owner = "kavita";
        group = "kavita";
        mode = "0400";
      };

      homelab.services.authelia = {
        rules = [
          {
            domain = [
              cfg.domain
            ];
            policy = "one_factor";
            subject = [
              "group:admin"
              "group:books"
            ];
          }
        ];

        oidc = [
          {
            client_id = "kavita";
            client_name = "kavita";
            client_secret = "$pbkdf2-sha512$310000$esDYsY41iTLuZIyeYNi6lQ$yYtUGACAIxC0D1jQ7kui147Xv1hJqJFot0LCQxsA2taFYwLoLn22BXBmN.S.AqgZ6oXzS5yJy0scQHHDT1G9Ng";
            public = false;
            authorization_policy = "one_factor";
            redirect_uris = [
              "https://${cfg.domain}.${vars.baseDomain}/signin-oidc"
              "https://${cfg.domain}.${vars.baseDomain}/signout-callback-oidc"
            ];
            scopes = [
              "openid"
              "profile"
              "email"
              "offline_access"
              "groups"
              "roles"
            ];
            token_endpoint_auth_method = "client_secret_post";

          }
        ];
      };
      networking.firewall.allowedTCPPorts = [ cfg.port ];

      services.kavita = {
        enable = true;
        package = pkgs.unstable.kavita;
        tokenKeyFile = config.sops.secrets."kavita/token_key".path;
        settings = {
          AllowIFraming = false;
          OpenIdConnectSettings = {
            Authority = "https://auth.${vars.baseDomain}";
            ClientId = "kavita";
            Secret = "@OIDC_SECRET@";
            CustomScopes = [
              "groups"
            ];
            Enabled = true;
          };
          Port = cfg.port;
        };
      };

      #######################################################################################################################################
      #                                                  Unsure if theres a better way to do this.                                          #
      # Copying the module definition: https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/services/web-apps/kavita.nix#L88-L93 #
      #######################################################################################################################################

      systemd.services.kavita = {
        serviceConfig = {
          LoadCredential = [ "oidc_secret:${config.sops.secrets."kavita/oidc_secret".path}" ];
        };
        preStart = lib.mkAfter ''
          ${pkgs.replace-secret}/bin/replace-secret '@OIDC_SECRET@' \
              ''${CREDENTIALS_DIRECTORY}/oidc_secret \
              '${config.services.kavita.dataDir}/config/appsettings.json'
        '';
      };
    };
}
