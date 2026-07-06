{ config, lib, ... }:
let
  cfg = config.homelab.services.monitoring.loki;
in

{
  options.homelab.services.monitoring.loki = {
    enable = lib.mkEnableOption "Enable Loki Log Aggreation";
    port = lib.mkOption { default = 3100; };
  };

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.loki = {
      enable = true;
      configuration = {
        auth_enabled = false;
        server.http_listen_port = cfg.port;

        common = {
          path_prefix = "/var/lib/loki";
          replication_factor = 1;
          ring = {
            kvstore.store = "inmemory";
            instance_addr = "0.0.0.0";
          };

        };

        storage_config.filesystem.directory = "/var/lib/loki/chunks";

        compactor = {
          retention_enabled = true;
          delete_request_store = "filesystem";
        };

        limits_config.retention_period = "30d";

        schema_config.configs = [
          {
            from = "2025-01-01";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };
    };
  };
}
