{ config, lib, ... }:

let
  vars = config.homelab;
  monitoring = vars.services.monitoring;
  cfg = monitoring.prometheus;

  exporter-port = vars.services.monitoring.node-exporter.port;
in
{
  options.homelab.services.monitoring.prometheus = {
    enable = lib.mkEnableOption "Enable Prometheus Metric Logging";
    port = lib.mkOption { default = 9090; };
  };

  config = lib.mkIf cfg.enable {

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

        {
          job_name = "grafana";
          static_configs = [
            {
              targets = [ "127.0.0.1:${toString vars.services.grafana.port}" ];
              labels.host = "olympus";
            }
          ];
        }

        {
          job_name = "prometheus";
          static_configs = [
            {
              targets = [ "127.0.0.1:${toString cfg.port}" ];
              labels.host = "olympus";
            }
          ];
        }

        {
          job_name = "loki";
          static_configs = [
            {
              targets = [ "127.0.0.1:${toString monitoring.loki.port}" ];
              labels.host = "olympus";
            }
          ];
        }

      ];
    };
  };
}
