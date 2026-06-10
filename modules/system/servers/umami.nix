(import ../../../utils/mkService.nix) {
  name = "umami";
  port = 3010;
  domain = "analytics";

  routing.protected = false;
  routing.healthPath = "/api/heartbeat";

  homepage = {
    group = "Monitoring";
    description = "Website Analytics";
  };

  extraConfig =
    {
      cfg,
      config,
      ...
    }:
    {

      sops.secrets."umami/app_secret" = {
        sopsFile = ../../../secrets/services.yaml;
      };

      services.umami = {
        enable = true;
        createPostgresqlDatabase = true;
        settings = {
          APP_SECRET_FILE = config.sops.secrets."umami/app_secret".path;
          PORT = cfg.port;
          HOSTNAME = "0.0.0.0";
          TRACKER_SCRIPT_NAME = [ "umami.js" ];
        };
      };

    };

}
