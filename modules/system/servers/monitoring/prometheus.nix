{ config, lib, ... }:

let
  vars = config.homelab;
  cfg = vars.services.monitoring.prometheus;

  exporter-port = vars.services.monitoring.node-exporter.port;
in
{
  options.homelab.services.monitoring.prometheus = {
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
              targets = [ "${vars.coreIP}:${toString exporter-port}" ];
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
              targets = [ "${vars.ingressIP}:${toString exporter-port}" ];
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
