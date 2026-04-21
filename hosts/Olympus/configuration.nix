{
  config,
  pkgs,
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
  networking.bridges.br0.interfaces = [ "enp1s0" ];
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

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", KERNEL=="vm-hermes", RUN+="${pkgs.iproute2}/bin/ip link set vm-hermes master br0"
  '';

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  microvm.vms.Hermes = {
    flake = self;
    autostart = true;
    restartIfChanged = true;
  };

  systemd.services."microvm@Hermes" = {
    after = [ "sops-nix.service" ];
    wants = [ "sops-nix.service" ];
  };

  sops.secrets."tailscale/auth_key" = { };

  sops.secrets."cloudflare/api_token" = {
    sopsFile = ../../secrets/services.yaml;
  };

  sops.secrets."personal/email" = {
    sopsFile = ../../secrets/services.yaml;
  };

  sops.templates."traefik.env".content = ''
    CF_DNS_API_TOKEN=${config.sops.placeholder."cloudflare/api_token"}
    ACME_EMAIL=${config.sops.placeholder."personal/email"}
  '';

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    authKeyFile = config.sops.secrets."tailscale/auth_key".path;
    extraUpFlags = [
      "--advertise-routes=192.168.0.0/24"
      "--advertise-exit-node"
    ];
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
    LidSwitchIgnoreInhibited = "no";
  };

  users.groups.media = { };
  users.users.peaterpita.extraGroups = [ "media" ];

  systemd.tmpfiles.rules = [
    "d /mnt/media 0775 root media - -"
    "d /mnt/media/music 2775 root media - -"
    "d /mnt/media/movies 2775 root media - -"
    "d /mnt/media/landing 2775 root media - -"
  ];

  homelab.services = {
    # authentik.enable = true;
    jellyfin.enable = true;
    navidrome.enable = true;
    # mealie.enable = true;
    # nextcloud.enable = true;
    glances.enable = true;
    kavita.enable = true;
    speedtest-tracker.enable = true;

    samba = {
      enable = true;
      shares = {
        movies = {
          path = "/mnt/media/movies";
        };
        music = {
          path = "/mnt/media/music";
        };
        books = {
          path = "/mnt/media/books";
        };
      };
    };

    homepage = {
      enable = true;
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

  system.stateVersion = "25.11";
}
