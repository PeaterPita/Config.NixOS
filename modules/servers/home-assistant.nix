(import ../../utils/mkService.nix) {
  name = "home-assistant";
  port = 8843;
  domain = "ha";

  routing = {
    protected = true;
  };

  homepage = {
    icon = "home-assistant";
    group = "Apps";
    description = "Home Automation";

  };

  extraConfig =
    {
      cfg,
      vars,
      ...
    }:

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

      ################################################################
      # Docs: https://www.home-assistant.io/docs/configuration/basic #
      ################################################################
      services.home-assistant = {
        enable = true;
        extraComponents = [
          "mqtt"
          "zha"
          "isal"
        ];

        config = {
          default_config = { };

          http = {
            server_port = cfg.port;
            trusted_proxies = [
              "${vars.ingressIP}"
            ];
            use_x_forwarded_for = true;
          };

          homeassistant = {
            time_zone = "Europe/London";
          };
        };
      };

    };
}
