{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.services.authentik;
  vars = config.homelab;

  AUTHENTIK_IMAGE = "ghcr.io/goauthentik/server:2026.2.0";

in

{
  options.homelab.services.authentik = {
    enable = lib.mkEnableOption "Enable the Authentik identiy provider service";
  };

  config = lib.mkIf cfg.enable {

    homelab.services.homepage.groups."Security" = [
      {
        Authentik = {
          icon = "authentik.png";
          href = "https://auth.${vars.baseDomain}";
          description = "User management and authentication";
          ping = "https://127.0.0.1:9000";
        };
      }
    ];

    sops.secrets."authentik/secret_key" = {
      sopsFile = ../../../secrets/services.yaml;
    };
    sops.secrets."authentik/db_pass" = {
      sopsFile = ../../../secrets/services.yaml;
      owner = config.systemd.services.postgresql.serviceConfig.User;
    };

    sops.templates."authentik.env".content = ''
      AUTHENTIK_SECRET_KEY=${config.sops.placeholder."authentik/secret_key"}
      AUTHENTIK_POSTGRESQL__PASSWORD=${config.sops.placeholder."authentik/db_pass"}
    '';

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
      authentication = lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 md5
        host all all ::1/128 md5'';
    };

    systemd.services.postgresql.postStart = lib.mkAfter ''
      AUTH_DB_PASS=$(cat ${config.sops.secrets."authentik/db_pass".path})
      ${config.services.postgresql.package}/bin/psql -tA -c "Alter ROLE authentik WITH PASSWORD '$AUTH_DB_PASS';"
    '';

    services.redis.servers.authentik = {
      enable = true;
      port = 6379;
    };

    virtualisation.oci-containers.containers = {
      authentik-server = {
        image = AUTHENTIK_IMAGE;
        cmd = [ "server" ];

        environment = {
          AUTHENTIK_REDIS__HOST = "127.0.0.1";
          AUTHENTIK_POSTGRESQL__HOST = "127.0.0.1";

          AUTHENTIK_POSTGRESQL__USER = "authentik";
          AUTHENTIK_POSTGRESQL__NAME = "authentik";
        };
        environmentFiles = [ config.sops.templates."authentik.env".path ];
        extraOptions = [ "--network=host" ];
      };

      authentik-worker = {
        image = AUTHENTIK_IMAGE;
        cmd = [ "worker" ];

        environment = {
          AUTHENTIK_REDIS__HOST = "127.0.0.1";
          AUTHENTIK_POSTGRESQL__HOST = "127.0.0.1";

          AUTHENTIK_POSTGRESQL__USER = "authentik";
          AUTHENTIK_POSTGRESQL__NAME = "authentik";
        };

        environmentFiles = [ config.sops.templates."authentik.env".path ];
        extraOptions = [ "--network=host" ];
      };
    };

  };
}
