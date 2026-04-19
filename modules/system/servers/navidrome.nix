{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.navidrome;
  vars = config.homelab;
in

{
  options.homelab.services.navidrome = {
    enable = lib.mkEnableOption "Enable the Jellyfin Media Streaming Service";
  };

  config = lib.mkIf cfg.enable {

    homelab.services.homepage.groups."Core" = [
      {
        Navidrome = {
          icon = "navidrome.png";
          href = "http://navidrome.${vars.baseDomain}";
          ping = "http://127.0.0.1:${builtins.toString config.homelab.ports.navidrome}";
        };
      }
    ];

    networking.firewall.allowedTCPPorts = [ vars.ports.navidrome ];

    services.navidrome = {
      enable = true;
      openFirewall = true;
      settings = {
        MusicFolder = "/mnt/media/music";
        Address = "0.0.0.0";
        Port = vars.ports.navidrome;
      };
    };
  };

}
