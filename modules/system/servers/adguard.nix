{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.adguard;

in

{
  options.homelab.services.adguard = {
    enable = lib.mkEnableOption "Enable the AdGuard Home DNS service";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      53
      3000
    ];
    networking.firewall.allowedUDPPorts = [ 53 ];

    services.adguardhome = {
      enable = true;
      mutableSettings = true;
      settings = {
        dns = {
          bind_hosts = [ "0.0.0.0" ];
          port = 53;
          bootstrap_dns = [ "1.1.1.1" ];
          upstream_dns = [ "1.1.1.1" ];
        };
        http = {
          address = "0.0.0.0";
          port = 3000;
        };
      };

    };
  };

}
