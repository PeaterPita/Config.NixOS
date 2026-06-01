{
  config,
  lib,
  pkgs,
  ...
}:

let
  vars = config.homelab;
  cfg = vars.services.seerr;
in

{
  options.homelab.services.seerr = {
    enable = lib.mkEnableOption "Enable the seerr requestment platform";
    port = lib.mkOption { default = 5055; };
    domain = lib.mkOption { default = "seerr.${vars.baseDomain}"; };
  };

  config = lib.mkIf cfg.enable {

    homelab.services.homepage.groups."Apps" = [
      {
        Jellyseerr = {
          icon = "seerr.png";
          href = "http://${cfg.domain}";
          description = "Requests";
          ping = "http://127.0.0.1:${builtins.toString cfg.port}";
        };
      }
    ];

    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];

    services.seerr.enable = true;

  };

}
