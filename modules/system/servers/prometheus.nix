(import ../../../utils/mkService.nix) {
  name = "prometheus";
  port = 9090;

  homepage = {
    group = "Logging";
    description = "Metric Logging";

  };

  routing = {
    protected = true;
  };

  extraConfig =
    { cfg, vars, ... }:
    {

      homelab.services.authelia.rules = [
        {
          domain = [
            "${cfg.domain}.${vars.baseDomain}"
          ];
          policy = "one_factor";
          subject = [
            "group:admin"
          ];
        }
      ];

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

        ];

      };

    };
}
