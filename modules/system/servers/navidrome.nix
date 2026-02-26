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

    # homelab.services.homepage.groups."Core" = [
    #   {
    #     Jellyfin = {
    #       icon = "navidrome.png";
    #       href = "https://navidrome.${vars.baseDomain}";
    #       ping = "https://navidrome.${vars.baseDomain}";
    #     };
    #   }
    # ];

    services.navidrome = {
      enable = true;
      openFirewall = true;
      settings = {
        MusicFolder = "/mnt/media/music";
        Address = "0.0.0.0";
        Port = 4533;
      };
    };
  };

}
