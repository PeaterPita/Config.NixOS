{
  config,
  lib,
  inputs,
  ...
}:

#############################################################
#                  Potentially usful docs                   #
# https://microvm-nix.github.io/microvm.nix/interfaces.html #
#############################################################

let
  cfg = config.homelab;
  services = cfg.services;
in

{
  imports = [
    inputs.microvm.nixosModules.microvm
  ];

  microvm = {
    hypervisor = "qemu";
    mem = 1024;
    vcpu = 2;
    vsock.cid = 3;

    interfaces = [
      {
        type = "tap";
        id = "vm-hermes";
        mac = "02:00:00:00:01:01";
      }
    ];

    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }
      # {
      #   source = "/home/peaterpita/.config/sops/age";
      #   mountPoint = "/run/sops-age";
      #   tag = "sops-age";
      #   proto = "virtiofs";
      # }
      {
        source = "/run/secrets/rendered";
        mountPoint = "/run/host-secrets";
        tag = "host-secrets";
        proto = "virtiofs";
      }
    ];

    volumes = [
      {
        mountPoint = "/var";
        image = "hermes-var.img";
        size = 16; # GB
      }
    ];
  };

  # sops.age.keyFile = lib.mkForce "/run/sops-age/keys.txt";

  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks."10-lan" = {
      matchConfig.MACAddress = "02:00:00:00:01:01";
      networkConfig = {
        Address = "${cfg.ingressIP}/24";
        Gateway = "192.168.0.1";
        DNS = "127.0.0.1";
      };
    };
  };

  services.resolved.extraConfig = ''
    DNS=1.1.1.1
    DNSStubListener=no
  '';

  homelab.services = {
    glances.enable = true;
    adguard = {
      enable = true;
      rewrites = [
        {
          domain = "*.${cfg.baseDomain}";
          answer = cfg.ingressIP;
        }
        {
          domain = cfg.baseDomain;
          answer = cfg.ingressIP;
        }
      ];
    };

    traefik = {
      enable = true;
      environmentFile = "/run/host-secrets/traefik.env";
      services = {
        adguard = {
          port = 3000;
          middlewares = [ "internal-only" ];
        };
        auth = {
          host = cfg.coreIP;
          port = services.authentik.port;
        };

        books = {
          host = cfg.coreIP;
          port = services.kavita.port;
          middlewares = [ "internal-only" ];
        };
        home = {
          host = cfg.coreIP;
          port = services.homepage.port;
          middlewares = [ "internal-only" ];
        };
        jellyfin = {
          host = cfg.coreIP;
          port = services.jellyfin.port;
          middlewares = [ "internal-only" ];
        };
        navidrome = {
          host = cfg.coreIP;
          port = services.navidrome.port;
          middlewares = [ "internal-only" ];
        };

        lldap = {
          host = cfg.coreIP;
          port = services.lldap.webport;
          middlewares = [ "internal-only" ];
        };

        speed = {
          host = cfg.coreIP;
          port = services.speedtest-tracker.port;
          middlewares = [ "internal-only" ];
        };
      };

      publicServices = {
        nextcloud = {
          host = cfg.coreIP;
          port = services.nextcloud.port;
        };
      };
    };
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  system.stateVersion = "25.11";
}
