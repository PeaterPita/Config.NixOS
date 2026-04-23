{
  config,
  lib,
  ...
}:

########################################################################
#                        Maybe good examples:                          #
# https://github.com/lldap/lldap/blob/main/example_configs/jellyfin.md #
########################################################################

let
  cfg = config.homelab.services.lldap;
  vars = config.homelab;
in

{
  options.homelab.services.lldap = {
    enable = lib.mkEnableOption "Enable lldap";
    domain = lib.mkOption { default = "lldap.${vars.baseDomain}"; };
    port = lib.mkOption { default = 3890; };
    webport = lib.mkOption { default = 17170; };
  };

  config = lib.mkIf cfg.enable {

    sops.secrets."lldap/jwt_secret" = {
      sopsFile = ../../../secrets/services.yaml;
      mode = "0444";
    };

    sops.secrets."lldap/admin_pass" = {
      sopsFile = ../../../secrets/services.yaml;
      mode = "0444";
    };

    homelab.services.homepage.groups."Infrastructure" = [
      {
        lldap = {
          icon = "lldap.png";
          href = "http://${cfg.domain}";
          description = "User management";
        };
      }
    ];

    homelab.services.authelia.rules = [
      {
        domain = [
          cfg.domain
        ];
        policy = "two_factor";
        subject = [ "group:admin" ];
      }
    ];

    networking.firewall.allowedTCPPorts = [
      cfg.port
      cfg.webport
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
