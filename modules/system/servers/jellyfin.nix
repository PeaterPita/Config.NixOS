{
  config,
  lib,
  pkgs,
  ...
}:

let
  vars = config.homelab;
  cfg = vars.services.jellyfin;
in

{
  options.homelab.services.jellyfin = {
    enable = lib.mkEnableOption "Enable the Jellyfin Media Streaming Service";
    port = lib.mkOption { default = 8096; };
  };

  config = lib.mkIf cfg.enable {

    homelab.services.homepage.disks = [ "/mnt/media/movies" ];

    homelab.services.homepage.groups."Media" = [
      {
        Jellyfin = {
          icon = "jellyfin.png";
          href = "http://jellyfin.${config.homelab.baseDomain}";
          description = "Movies & TV";
          ping = "http://127.0.0.1:${builtins.toString cfg.port}";
        };
      }
    ];

    homelab.services.authelia.rules = [
      {
        domain = [
          "jellyfin.${vars.baseDomain}"
        ];
        policy = "one_factor";
        subject = [
          "group:family"
          "group:admin"
        ];
      }
    ];

    networking.firewall.allowedTCPPorts = [ cfg.port ];

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
