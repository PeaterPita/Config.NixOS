{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.authentik;
  vars = config.homelab;

in

{
  options.homelab.services.authentik = {
    enable = lib.mkEnableOption "Enable the Authentik identiy provider service";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      9000
      9443
    ];

    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "authentik" ];
      ensureUsers = [
        {
          name = "authentik";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.authentik = {
      enable = true;
      port = 6379;
    };

    virtualisation.oci-containers.containers = {
      authentik-server = {
        image = "ghcr.io/goauthentik/server:2025.12.4";
        ports = [
          "9000:9000"
          "9443:9443"
        ];

        environment = {
          AUTHENTIK_REDIS__HOST = "127.0.0.1";
          AUTHENTIK_POSTGRESQL__HOST = "127.0.0.1";
          AUTHENTIK_POSTGRESQL__USER = "authentik";
          AUTHENTIK_POSTGRESQL__NAME = "authentik";
        };
      };
    };

  };
}
