{
  pkgs,
  ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--advertise-routes=192.168.0.0/24" ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
      53
      3000
    ];
    allowedUDPPorts = [ 53 ];

  };

  services.adguardhome = {
    enable = true;
    mutableSettings = true;
    settings = {
      dns = {
        bind_hosts = [ "0.0.0.0" ];
        port = 53;
        bootstrap_dns = [ "1.1.1.1" ];
        upstream_dns = [ "1.1.1.1" ];
      };
      http = {
        address = "0.0.0.0";
        port = 3000;
      };
    };

  };

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint.to = "websecure";
          http.redirections.entryPoint.scheme = "https";
        };
        websecure = {
          address = ":443";
        };
      };
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          nextcloud = {
            rule = "Host(`nextcloud.home.arpa`)";
            service = "nextcloud-backend";
            entryPoints = [ "websecure" ];
          };
          pterodactyl = {
            rule = "Host(`panel.home.arpa`)";
            service = "ptero-backend";
            entryPoints = [ "websecure" ];
          };

        };
        services = {
          nextcloud-backend = {
            loadBalancer.servers = [
              { url = "http://192.168.X.X:8080"; }
            ];
          };
          ptero-backend = {
            loadBalancer.servers = [
              { url = "http://192.168.X.Y:80"; }
            ];
          };
        };
      };
    };

  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
