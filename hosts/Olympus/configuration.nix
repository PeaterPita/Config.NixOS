{
  config,
  inputs,
  self,
  ...
}:

{
  imports = [
    inputs.microvm.nixosModules.host
  ];

  networking.useDHCP = false;
  networking.bridges.br0.interfaces = [ "int" ];
  networking.interfaces.br0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = config.homelab.coreIP;
        prefixLength = 24;
      }
    ];
  };
  networking.defaultGateway = "192.168.0.1";
  networking.nameservers = [
    config.homelab.ingressIP
    "1.1.1.1"
  ];

  systemd.network.networks."30-hermes-tap" = {
    matchConfig.Name = "vm-hermes";
    networkConfig.Bridge = "br0";
    linkConfig.RequiredForOnline = "enslaved";
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  microvm.vms.Hermes = {
    flake = self;
    autostart = true;
  };

  sops.secrets."tailscale/auth_key" = { };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    authKeyFile = config.sops.secrets."tailscale/auth_key".path;
    extraUpFlags = [
      "--advertise-routes=192.168.0.0/24"
      "--advertise-exit-node"
    ];
  };

  homelab.services = {
    authentik.enable = true;
    jellyfin.enable = true;
    navidrome.enable = true;
    nextcloud.enable = true;

    homepage = {
      enable = true;

      groups = {
        "Infrastructure" = [
          {
            Traefik = {
              icon = "traefik.png";
              href = "https://traefik.${config.homelab.baseDomain}";
              description = "Reverse Proxy";
            };
          }
          {
            AdGuard = {
              icon = "adguard-home.png";
              href = "https://adguard.${config.homelab.baseDomain}";
              description = "DNS / Ad Blocking";
            };
          }
        ];

        "Media" = [
          {
            Jellyfin = {
              icon = "jellyfin.png";
              href = "https://jellyfin.${config.homelab.baseDomain}";
              description = "Media Streaming";
            };
          }
          {
            Navidrome = {
              icon = "navidrome.png";
              href = "https://navidrome.${config.homelab.baseDomain}";
              description = "Music Streaming";
            };
          }
        ];

        "Storage" = [
          {
            Nextcloud = {
              icon = "nextcloud.png";
              href = "https://nextcloud.${config.homelab.baseDomain}";
              description = "Personal Cloud Storage";
            };
          }
        ];

        "Security" = [
          {
            Authentik = {
              icon = "authentik.png";
              href = "https://auth.${config.homelab.baseDomain}";
              description = "SSO / User Management";
            };
          }
        ];
      };
    };
  };

  networking.hostId = "00000000";

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  services.zfs = {
    autoScrub.enable = true;
    autoScrub.interval = "monthly";
    trim.enable = true;
  };

  fileSystems = {
    "/mnt/media/movies" = {
      device = "tank/media/movies";
      fsType = "zfs";
    };

    "/mnt/media/music" = {
      device = "tank/media/music";
      fsType = "zfs";
    };

    "/mnt/nextcloud" = {
      device = "tank/nextcloud";
      fsType = "zfs";
    };
  };

  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
  };

  system.stateVersion = "25.11";
}
