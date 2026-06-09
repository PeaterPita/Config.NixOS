{
  config,
  lib,
  pkgs,
  ...
}:
let
  vars = config.homelab;
  cfg = vars.services.monitoring.alloy;
in
{
  options.homelab.services.monitoring.alloy = {
    enable = lib.mkEnableOption "Alloy Log Exporter";
  };

  config = lib.mkIf cfg.enable {
    services.alloy = {
      enable = true;

    };

    environment.etc."alloy/config.alloy".text = ''
      loki.source.journal "journal" {
          forward_to = [loki.write.default.receiver]
          labels = {
              host = "${config.networking.hostName}",
              job = "journal",
          }
      }

      loki.write "default" {
          endpoint {
              url = "http://${vars.coreIP}:${toString vars.services.monitoring.loki.port}/loki/api/v1/push"
          }
      }
    '';

  };

}
