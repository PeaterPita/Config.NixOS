{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.homepage;
  vars = config.homelab;

in

{
  options.homelab.services.homepage = {
    enable = lib.mkEnableOption "Enable the Homepage dashboard ";

    groups = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.attrs);
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8082 ];

    sops.secrets."proxmox-api-token" = {
      sopsFile = ../../../secrets/services.yaml;
    };

    sops.secrets."gitea-token" = {
      sopsFile = ../../../secrets/services.yaml;
    };

    sops.templates."homepage.env".content = ''
      HOMEPAGE_VAR_PROXMOX_TOKEN=${config.sops.placeholder."proxmox-api-token"}
      HOMEPAGE_VAR_GITEA_TOKEN=${config.sops.placeholder."gitea-token"}
    '';

    services.homepage-dashboard = {
      enable = true;
      environmentFile = config.sops.templates."homepage.env".path;

      allowedHosts = lib.concatStringsSep "," [
        vars.baseDomain
        "${vars.baseDomain}:8082"
        "127.0.0.1:8082"
        vars.ingressIP
      ];

      settings = {
        title = "PeaterPita Home";
        theme = "dark";
      };
      widgets = [

        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
          };

        }

      ];

      services = lib.mapAttrsToList (name: items: { "${name}" = items; }) cfg.groups;

    };
    homelab.services.homepage.groups = {
      "Security" = [
        {
          traefik = {
            icon = "traefik.png";
            href = "https://traefik.${vars.baseDomain}";
            description = "Reverse Proxy";
            ping = "https://${vars.ingressIP}:";
          };
        }
      ];

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

        {
          "Hypixel" = {
            icon = "minecraft.png";
            description = "The Hypixel minecraft server";
            widget = {
              type = "minecraft";
              url = "udp://play.hypixel.net";
            };
          };
        }

        {
          "The Universe Network" = {
            icon = "minecraft.png";
            description = "The UniverseNetwork minecraft server";
            widget = {
              type = "minecraft";
              url = "udp://play.theuniverse.network";
            };
          };
        }
      ];
    };
  };
}
