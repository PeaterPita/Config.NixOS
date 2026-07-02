(import ../../../utils/mkService.nix) {
  name = "grafana";
  port = 8675;
  domain = "dash";

  routing.protected = true;

  homepage = {
    group = "Monitoring";
    description = "Dashbaords & Monitoring";
  };

  extraConfig =
    {
      vars,
      cfg,
      config,
      ...
    }:
    {

      sops.secrets."grafana/secret_key" = {
        owner = "grafana";
        group = "grafana";
      };

      homelab.services.authelia.rules = [
        {
          domain = [ "${cfg.domain}.${vars.baseDomain}" ];
          policy = "one_factor";
          subject = [ "group:admin" ];

        }
      ];

      services.grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = "0.0.0.0";
            http_port = cfg.port;
            root_url = "https://${cfg.domain}.${vars.baseDomain}";
          };

          security.secret_key = "$__file{${config.sops.secrets."grafana/secret_key".path}}";
        };

        provision = {

          datasources.settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://127.0.0.1:${toString vars.services.monitoring.prometheus.port}";
              isDefault = true;
            }

            {
              name = "Loki";
              type = "loki";
              url = "http://127.0.0.1:${toString vars.services.monitoring.loki.port}";
            }
          ];
          dashboards.settings.providers = [
            {
              name = "default";
              options.path = ./dashboards;
            }
          ];
        };

      };

    };
}
