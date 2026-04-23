{
  config,
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
        size = 1000;
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
        Gateway = cfg.gatewayIP;
        DNS = "127.0.0.1";
      };
    };
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4UunpG+zwcD8K6yKG0Tl9DOG4fbl+tb0MjIVIOGNyp"
    ];
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
          port = services.adguard.port;
          middlewares = [ "internal-only" ];
          protected = true;
        };

        books = {
          host = cfg.coreIP;
          port = services.kavita.port;
        };
        meals = {
          host = cfg.coreIP;
          port = services.mealie.port;
        };
        home = {
          host = cfg.coreIP;
          port = services.homepage.port;
          protected = true;
        };
        jellyfin = {
          host = cfg.coreIP;
          port = services.jellyfin.port;
        };
        music = {
          host = cfg.coreIP;
          port = services.navidrome.port;
          protected = true;
        };

        lldap = {
          host = cfg.coreIP;
          port = services.lldap.webport;
          middlewares = [ "internal-only" ];
          protected = true;
        };

        speed = {
          host = cfg.coreIP;
          port = services.speedtest-tracker.port;
          protected = true;
        };
      };

      publicServices = {
        nextcloud = {
          host = cfg.coreIP;
          port = services.nextcloud.port;
          protected = true;
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
