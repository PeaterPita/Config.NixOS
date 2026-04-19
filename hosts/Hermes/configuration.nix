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

{
  imports = [
    inputs.microvm.nixosModules.microvm
  ];

  microvm = {
    hypervisor = "qemu";
    mem = 3084;
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
      {
        source = "/home/peaterpita/.config/sops/age";
        mountPoint = "/run/sops-age";
        tag = "sops-age";
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

  sops.age.keyFile = lib.mkForce "/run/sops-age/keys.txt";

  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks."10-lan" = {
      matchConfig.MACAddress = "02:00:00:00:01:01";
      networkConfig = {
        Address = "${config.homelab.ingressIP}/24";
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
          domain = "*.${config.homelab.baseDomain}";
          answer = config.homelab.ingressIP;
        }
        {
          domain = config.homelab.baseDomain;
          answer = config.homelab.ingressIP;
        }
      ];
    };

    traefik = {
      enable = true;
      services = {
        adguard = {
          port = 3000;
          middlewares = [ "internal-only" ];
        };
        auth = {
          host = config.homelab.coreIP;
          port = config.homelab.ports.authentik;
        };
        jellyfin = {
          host = config.homelab.coreIP;
          port = config.homelab.ports.jellyfin;
          middlewares = [ "internal-only" ];
        };
        navidrome = {
          host = config.homelab.coreIP;
          port = config.homelab.ports.navidrome;
          middlewares = [ "internal-only" ];
        };
      };

      publicServices = {
        nextcloud = {
          host = config.homelab.coreIP;
          port = 80;
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
