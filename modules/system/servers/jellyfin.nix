{
  config,
  lib,
  pkgs,
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

    homelab.services.homepage.groups."Core" = [
      {
        Jellyfin = {
          icon = "jellyfin.png";
          href = "http://jellyfin.${config.homelab.baseDomain}";
          ping = "http://127.0.0.1:${builtins.toString config.homelab.ports.jellyfin}";
        };
      }
    ];

    networking.firewall.allowedTCPPorts = [ config.homelab.ports.jellyfin ];

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

    services.jellyfin = {
      enable = true;
    };
  };

}
