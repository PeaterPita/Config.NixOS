{
  config,
  lib,
  pkgs,
  ...
}:

let
  vars = config.homelab;
  cfg = vars.services.umami;
in

{
  options.homelab.services.umami = {
    enable = lib.mkEnableOption "Enable Umami";
    port = lib.mkOption { default = 3010; };
    domain = lib.mkOption { default = "analytics.${vars.baseDomain}"; };
  };

  config = lib.mkIf cfg.enable {

    sops.secrets."umami/app_secret" = {

      sopsFile = ../../../secrets/services.yaml;
    };

    homelab.services.homepage.groups."Apps" = [
      {
        Umami = {
          icon = "umami.png";
          href = "https://${cfg.domain}";
          description = "Website Analytics";
          ping = "http://127.0.0.1:${builtins.toString cfg.port}";
        };
      }
    ];

    networking.firewall.allowedTCPPorts = [ cfg.port ];

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
