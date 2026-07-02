{ config, lib, ... }:

let
  cfg = config.homelab.services.monitoring.node-exporter;
in
{
  options.homelab.services.monitoring.node-exporter = {
    enable = lib.mkEnableOption "Enable Prometheus Node Exporter";
    port = lib.mkOption { default = 9100; };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.prometheus.exporters.node = {
      enable = true;
      inherit (cfg) port;
      enabledCollectors = [ "systemd" ];
    };
  };

}
