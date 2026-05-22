{
  config,
  lib,
  pkgs,
  ...
}:

let
  vars = config.homelab;
  cfg = vars.services.jellyseerr;
in

{
  options.homelab.services.jellyseerr = {
    enable = lib.mkEnableOption "Enable the jellyseerr requestment platform";
    port = lib.mkOption { default = 5055; };
    domain = lib.mkOption { default = "jellyseerr.${vars.baseDomain}"; };
  };

  config = lib.mkIf cfg.enable {

    homelab.services.homepage.groups."Apps" = [
      {
        Jellyseerr = {
          icon = "jellyseerr.png";
          href = "http://${cfg.domain}";
          description = "Requests";
          ping = "http://127.0.0.1:${builtins.toString cfg.port}";
        };
      }
    ];

    homelab.services.authelia.rules = [
      {
        domain = [
          cfg.domain
        ];
        policy = "one_factor";
        subject = [
          "group:admin"
          "group:media"
        ];
      }
    ];

    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];

    services.jellyseerr.enable = true;

  };

}
