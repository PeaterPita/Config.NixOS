{
  config,
  lib,
  ...
}:
let
  vars = config.homelab;
  cfg = vars.services.monitoring.alloy;
in
{
  options.homelab.services.monitoring.alloy = {
    enable = lib.mkEnableOption "Alloy Log Exporter";
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    services.alloy = {
      enable = true;
      extraFlags = [ "--disable-reporting" ];

    };

    environment.etc."alloy/config.alloy".text = ''

        loki.relabel "journal" {
            forward_to = []
            rule {
                source_labels = ["__journal__systemd_unit"]
                target_label = "unit"
            }
        }

        loki.source.journal "journal" {
            forward_to = [loki.write.default.receiver]
            relabel_rules = loki.relabel.journal.rules
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


      ${cfg.extraConfig}
    '';
  };

}
