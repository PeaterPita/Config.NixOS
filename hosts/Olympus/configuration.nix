{
  pkgs,
  ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };

  services.redis.servers = {
    nextcloud = {
      enable = true;
    };
  };

  virtualisation.oci-containers.backend = "docker";

  # ############################################################
  # #                         SERVICES                         #
  # ############################################################

  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.home.arpa";

    config = {
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      adminpassFile = "/home/peaterpita/nixos/secrets/nextcloud-admin-pass";
    };
    configureRedis = true;
    datadir = "/mnt/media/nextcloud-data";
  };

  services.jellyfin = {
    enable = true;
  };

  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      MusicFolder = "/mnt/media/music";
      Address = "0.0.0.0";
      Port = 4533;
    };
  };

  services.homepage-dashboard = {
    enable = true;

    settings = {
      title = "PeaterPita Home";
      theme = "dark";
    };
    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
        };
      }

      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };

      }
    ];

    services = [
      {
        "Core" = [
          {
            Nextcloud = {
              icon = "nextcloud.png";
              href = "https://nextcloud.home.arpa";
              description = "Personal Cloud Storage";
              ping = "https://nextcloud.home.arpa";
            };
          }

          {
            Jellyfin = {
              icon = "jellyfin.png";
              href = "https://jellyfin.home.arpa";
              ping = "https://jellyfin.home.arpa";
            };
          }
        ];
      }

      {
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
        ];
      }

    ];
  };

  virtualisation.oci-containers.containers = {

    "vaultwarden" = {
      image = "vaultwarden/server:latest";
      ports = [ "8222:80" ];
      environment = {
        SIGNUPS_ALLOWED = "true";
      };
      volumes = [ "/var/lib/vaultwarden:/data" ];
    };

  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      8082
      8096
      4533
      8222
      2283
      9100
    ];
    allowedUDPPorts = [ 53 ];

  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
