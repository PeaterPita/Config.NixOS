(import ../../../utils/mkService.nix) {
  name = "speedtest-tracker";
  port = 8765;
  domain = "speed";

  homepage = {
    group = "Apps";
    description = "Internet Speed Testing";
  };

  extraConfig =
    {
      cfg,
      vars,
      config,
      ...
    }:
    {
      sops.secrets."speedtest/app_key" = {
        sopsFile = ../../../secrets/services.yaml;
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/speedtest-tracker 0750 1000 1000 -"
      ];
      sops.templates."speedtest-tracker.env".content = ''
        APP_KEY=${config.sops.placeholder."speedtest/app_key"}
      '';

      virtualisation.containers.enable = true;
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
      };

      homelab.services.authelia.rules = [
        {
          domain = [
            "${cfg.domain}.${vars.baseDomain}"
          ];
          policy = "two_factor";
          subject = [
            "group:admin"
          ];
        }
      ];
      virtualisation.oci-containers = {
        backend = "podman";
        containers = {
          speedtest-tracker = {
            image = "lscr.io/linuxserver/speedtest-tracker:latest";
            ports = [ "${toString cfg.port}:80" ];

            volumes = [ "/var/lib/speedtest-tracker:/config" ];
            environment = {
              PUID = "1000";
              PGID = "1000";
              APP_URL = "https://${cfg.domain}.${vars.baseDomain}";
              DISPLAY_TIMEZONE = "Europe/London";
              SPEEDTEST_SCHEDULE = "0 */4 * * *";

            };
            environmentFiles = [ config.sops.templates."speedtest-tracker.env".path ];
          };
        };
      };
    };
}
