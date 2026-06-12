########################################################################
#                        Maybe good examples:                          #
# https://github.com/lldap/lldap/blob/main/example_configs/jellyfin.md #
########################################################################

##########
# Groups #
##########
# admin
# media
# music
# books
# meals
# files
# home
# documents
(import ../../../utils/mkService.nix) {
  name = "lldap";
  port = 3890;

  extraOptions =
    { lib, ... }:
    {
      webport = lib.mkOption { default = 17170; };
    };

  routing = {
    protected = true;
    port = 17170;
    healthPath = "/";
    # middlewares = [ "internal-only" ];
  };

  homepage = {
    group = "Infrastructure";
    description = "User Management";
  };

  extraConfig =
    {
      vars,
      config,
      cfg,
      ...
    }:
    {
      networking.firewall.allowedTCPPorts = [
        cfg.webport
      ];
      sops.secrets."lldap/jwt_secret" = {
        sopsFile = ../../../secrets/services.yaml;
        mode = "0444";
      };

      sops.secrets."lldap/admin_pass" = {
        sopsFile = ../../../secrets/services.yaml;
        mode = "0444";
      };

      homelab.services.authelia.rules = [
        {
          domain = [
            "${cfg.domain}.${vars.baseDomain}"
          ];
          policy = "one_factor";
          subject = [ "group:admin" ];
        }
      ];

      services.lldap = {
        enable = true;
        settings = {
          http_host = "0.0.0.0";
          http_port = cfg.webport;

          ldap_host = "0.0.0.0";
          ldap_port = cfg.port;

          ldap_base_dn = "dc=peaterpita,dc=com";
          force_ldap_user_pass_reset = "always";

          jwt_secret_file = config.sops.secrets."lldap/jwt_secret".path;
          ldap_user_pass_file = config.sops.secrets."lldap/admin_pass".path;
        };
      };

    };

}
