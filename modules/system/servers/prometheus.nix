{ config, lib, ... }:

let
  vars = config.homelab;
  cfg = vars.services.prometheus;
in
{
  options.homelab.services.prometheus = {
    enable = lib.mkEnableOption "Enable Prometheus Metric Logging";
    port = lib.mkOption { default = 9090; };
  };

  config = {

    services.prometheus = {
      enable = true;
      port = cfg.port;

      retentionTime = "30d";

      globalConfig = {
        scrape_interval = "15s";
        evaluation_interval = "15s";
      };

      scrapeConfigs = [
        {
          job_name = "Olympus";
          static_configs = [
            {
              targets = [ "${vars.coreIP}:${toString vars.services.node-exporter.port}" ];
              labels = {
                host = "olympus";
              };
            }
          ];
        }

        {
          job_name = "Hermes";
          static_configs = [
            {
              targets = [ "${vars.ingressIP}:${toString vars.services.node-exporter.port}" ];
              labels = {
                host = "hermes";
              };
            }
          ];
        }

        {
          job_name = "Traefik";
          static_configs = [
            {
              targets = [ "${vars.ingressIP}:8082" ];
            }
          ];
        }
      ];
    };
  };
}
