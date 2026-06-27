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

  vars = config.homelab;

in

{
  imports = [
    inputs.microvm.nixosModules.host
    # inputs.disko.nixosModules.disko
  ];

  networking.useDHCP = false;
  networking.useNetworkd = true;

  systemd.network = {
    enable = true;

    netdevs."10-br0" = {
      netdevConfig = {
        Name = "br0";
        Kind = "bridge";
      };
    };

    networks = {
      "10-enp1s0" = {
        matchConfig.Name = "enp1s0";
        networkConfig.Bridge = "br0";
      };
      "10-br0" = {
        matchConfig.Name = "br0";
        networkConfig = {
          Address = "${vars.coreIP}/24";
          Gateway = vars.gatewayIP;
          DNS = vars.ingressIP;
        };
      };

      "20-vm" = {
        matchConfig.Name = "vm-*";
        networkConfig.Bridge = "br0";
      };

    };

  };

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

  sops.secrets."tailscale/auth_key" = {
    sopsFile = ../../secrets/services.yaml;
  };

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
    backup.enable = true;

    jellyfin.enable = true;
    navidrome.enable = true;
    mealie.enable = true;
    monitoring = {
      prometheus.enable = true;
      node-exporter.enable = true;
      json-exporter.enable = true;
      loki.enable = true;
      alloy.enable = true;

      geoipupdate.enable = true;
      glances.enable = true;
    };
    # kavita.enable = true;
    lldap.enable = true;
    authelia.enable = true;
    speedtest-tracker.enable = true;
    umami.enable = true;
    immich.enable = true;
    wakapi.enable = true;
    paperless-ngx.enable = true;
    woodpecker.enable = true;
    cache.enable = true;

    filebrowser-quantum.enable = true;
    grafana.enable = true;

    portfolio.enable = true;
    it-tools.enable = true;

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
      groups."Infrastructure" = [
        {
          Traefik = {
            icon = "traefik.png";
            description = "Reverse Proxy";
            href = "https://traefik.${vars.baseDomain}";
          };
        }
        {
          Adguard = {
            icon = "adguard-home.png";
            description = "DNS Blocking";
            href = "https://${vars.services.adguard.domain}";
          };
        }
      ];
    };
  };

  networking.hostId = "35ab6c06";
  # boot.supportedFilesystems = [ "zfs" ];

  services.zfs = {
    autoScrub.enable = true;
    autoScrub.interval = "monthly";
    trim.enable = true;
  };

  # disko.devices = {
  #   disk = builtins.listToAttrs (
  #     map (device: {
  #       name = baseNameOf device;
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
  #     };
  #   };
  #
  # };

  system.stateVersion = "25.11";
}
