{
  pkgs,
  config,
  ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  homelab.services = {
    traefik = {
      enable = true;
      services = {
        adguard = {
          port = 3000;
          middlewares = [ "internal-only" ];
        };

        pterodactyl = {
          host = config.homelab.coreIP;
          port = 80;
          middlewares = [ "internal-only" ];
        };
        nextcloud = {
          host = config.homelab.gameIP;
          port = 8080;
        };

      };
    };
    adguard.enable = true;
  };

  sops.secrets."tailscale/auth_key" = { };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  services.qemuGuest.enable = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    authKeyFile = config.sops.secrets."tailscale/auth_key".path;
    extraUpFlags = [
      "--advertise-routes=192.168.0.0/24"
      "--advertise-exit-node"
    ];
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
