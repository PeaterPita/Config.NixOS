{
  config,
  inputs,
  self,
  ...
}:

#############################################################################
#                            Useful docs                                    #
# Disko: https://github.com/nix-community/disko/blob/master/example/zfs.nix #
#############################################################################

let
  tankDrives = [
    "/dev/disk/by-id/???"
  ];

in

{
  imports = [
    inputs.microvm.nixosModules.host
    # inputs.disko.nixosModules.disko
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
    mealie.enable = true;
    # nextcloud.enable = true;

    samba = {
      enable = true;
      shares = {
        movies = {
          path = "/mnt/media/movies";
          comment = "Movie library";
        };
        music = {
          path = "/mnt/media/music";
          comment = "Music library";
        };
      };
    };

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

  networking.hostId = "35ab6c06";
  boot.supportedFilesystems = [ "zfs" ];

  services.zfs = {
    autoScrub.enable = true;
    autoScrub.interval = "monthly";
    trim.enable = true;
  };

  # disko.devices = {
  #   disk = {
  #     os-drive = {
  #       type = "disk";
  #       device = "";
  #       content = {
  #         type = "gpt";
  #         partitions = {
  #           ESP = {
  #             size = "1G";
  #             type = "EF00";
  #             content = {
  #               type = "filesystem";
  #               format = "vfat";
  #               mountpoint = "/boot";
  #               mountOptions = [ "umask=0077" ];
  #             };
  #           };
  #           root = {
  #             size = "100%";
  #             content = {
  #               type = "filesystem";
  #               format = "ext4";
  #               mountpoint = "/";
  #             };
  #           };
  #         };
  #       };
  #     };
  #   }
  #   // builtins.listToAttrs (
  #     map (device: {
  #       name = builtins.baseNameOf device;
  #       value = {
  #         type = "disk";
  #         inherit device;
  #         content = {
  #           type = "gpt";
  #           partitions.zfs = {
  #             size = "100%";
  #             content = {
  #               type = "zfs";
  #               pool = "tank";
  #             };
  #           };
  #         };
  #       };
  #     }) tankDrives
  #   );
  #
  #   zpool = {
  #     tank = {
  #       type = "zpool";
  #       mode = "raidz2";
  #       options = {
  #         ashift = "12";
  #         autotrim = "on";
  #
  #       };
  #       rootFsOptions = {
  #         compression = "lz4";
  #         acltype = "posixacl";
  #         xattr = "sa";
  #       };
  #       datasets = {
  #         "media/movies" = {
  #           type = "zfs_fs";
  #           mountpoint = "/mnt/media/movies";
  #         };
  #         "media/music" = {
  #           type = "zfs_fs";
  #           mountpoint = "/mnt/media/music";
  #         };
  #         "immich" = {
  #           type = "zfs_fs";
  #           mountpoint = "/mnt/immich";
  #         };
  #       };
  #     };
  #   };
  #
  # };

  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
  };

  system.stateVersion = "25.11";
}
