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
    port = lib.mkOption { default = 4533; };
    domain = lib.mkOption { default = "music.${vars.baseDomain}"; };
  };

  config = lib.mkIf cfg.enable {

    homelab.services.homepage.disks = [ "/mnt/media/music" ];

    users.users.navidrome.extraGroups = [ "media" ];
    homelab.services.homepage.groups."Media" = [
      {
        Navidrome = {
          icon = "navidrome.png";
          href = "http://${cfg.domain}";
          description = "Music Streaming";
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
          "group:family"
          "group:admin"
        ];
      }
    ];

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.navidrome = {
      enable = true;
      openFirewall = true;
      settings = {
        MusicFolder = "/mnt/media/music";
        Address = "0.0.0.0";
        Port = cfg.port;
      };
    };
  };

}
