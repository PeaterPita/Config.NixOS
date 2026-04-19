{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.adguard;
  vars = config.homelab;

in

{
  options.homelab.services.adguard = {
    enable = lib.mkEnableOption "Enable the AdGuard Home DNS service";

    rewrites = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            domain = lib.mkOption { type = lib.types.str; };
            answer = lib.mkOption { type = lib.types.str; };
          };
        }
      );
      default = [ ];
      description = "AdGuard Home DNS rewrite rules";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      53
      3000
    ];
    networking.firewall.allowedUDPPorts = [ 53 ];

    services.adguardhome = {
      enable = true;
      mutableSettings = false;
      settings = {
        dns = {
          bind_hosts = [ "0.0.0.0" ];
          port = 53;
          bootstrap_dns = [ "1.1.1.1" ];
          upstream_dns = [ "1.1.1.1" ];

        };

        filtering = {
          rewrites = map (r: {
            inherit (r) domain answer;
          }) cfg.rewrites;
        };

        http = {
          address = "0.0.0.0";
          port = 3000;
        };
      };
    };
  };

}
