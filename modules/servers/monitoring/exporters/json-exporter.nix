{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.services.monitoring.json-exporter;
  yaml = pkgs.formats.yaml { };
in
{
  options.homelab.services.monitoring.json-exporter = {
    enable = lib.mkEnableOption "Enable Prometheus Json Exporter";
    port = lib.mkOption { default = 9981; };
    modules = lib.mkOption { default = { }; };
  };

  config = lib.mkIf cfg.enable {

    users.groups."json-exporter" = { };
    users.users."json-exporter" = {
      isSystemUser = true;
      group = "json-exporter";
    };

    services.prometheus.exporters.json = {
      enable = true;
      inherit (cfg) port;
      configFile = yaml.generate "json-exporter.yaml" { inherit (cfg) modules; };

    };

  };

}
