{
  pkgs,
  config,
  ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  services.qemuGuest.enable = true;

  homelab.services = {
    authentik.enable = true;
    # nextcloud.enable = true;
    jellyfin.enable = true;
    navidrome.enable = true;
    homepage = {
      enable = true;

      groups = {
        "Security" = [
          {
            traefik = {
              icon = "traefik.png";
              href = "https://traefik.${config.homelab.baseDomain}";
              description = "Reverse Proxy";
              ping = "https://${config.homelab.ingressIP}:";
            };
          }
        ];

        "Games" = [

          {
            "Pterodactyl Panel" = {
              icon = "pterodactyl.png";
              href = "https://panel.home.arpa";
              description = "Minecraft server hosting";
              widget = {
                type = "pterodactyl";
                url = "http://192.168.1.Y";
                key = "";
              };
            };
          }

          {
            "Hypixel" = {
              icon = "minecraft.png";
              description = "The Hypixel minecraft server";
              widget = {
                type = "minecraft";
                url = "udp://play.hypixel.net";
              };
            };
          }

          {
            "The Universe Network" = {
              icon = "minecraft.png";
              description = "The UniverseNetwork minecraft server";
              widget = {
                type = "minecraft";
                url = "udp://play.theuniverse.network";
              };
            };
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [ nfs-utils ];

  fileSystems = {

    "/mnt/media/movies" = {
      device = "${config.homelab.storageIP}:/mnt/tank/Media/Movies";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout==600"
      ];

    };

    "/mnt/media/music" = {
      device = "${config.homelab.storageIP}:/mnt/tank/Media/Music";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout==600"
      ];

    };
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
