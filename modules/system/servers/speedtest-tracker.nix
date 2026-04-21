{
  config,
  lib,
  ...
}:

let
  vars = config.homelab;
  cfg = vars.services.speedtest-tracker;
in

{
  options.homelab.services.speedtest-tracker = {
    enable = lib.mkEnableOption "Enable speedtest-tracker";
    port = lib.mkOption { default = 8765; };
  };

  config = lib.mkIf cfg.enable {

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
            APP_URL = "http://speed.${vars.baseDomain}";
            DISPLAY_TIMEZONE = "Europe/London";
            SPEEDTEST_SCHEDULE = "0 */4 * * *";

          };
          environmentFiles = [ config.sops.templates."speedtest-tracker.env".path ];
        };
      };
    };

    homelab.services.homepage.groups."Tools" = [
      {
        Speedtest-Tracker = {
          icon = "speedtest-tracker.png";
          href = "http://speed.${vars.baseDomain}";
          ping = "http://127.0.0.1:${builtins.toString cfg.port}";
        };
      }
    ];
  };

}
