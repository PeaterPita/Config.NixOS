{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.jellyfin;
in

{
  options.homelab.services.jellyfin = {
    enable = lib.mkEnableOption "Enable the Jellyfin Media Streaming Service";
  };

  config = lib.mkIf cfg.enable {

    # homelab.services.homepage.groups."Core" = [
    #   {
    #     Jellyfin = {
    #       icon = "jellyfin.png";
    #       href = "https://jellyfin.home.arpa";
    #       ping = "https://jellyfin.home.arpa";
    #     };
    #   }
    # ];

    services.jellyfin = {
      enable = true;
    };
  };

}
