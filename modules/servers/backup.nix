{
  config,
  lib,
  pkgs,
  ...
}:

let
  vars = config.homelab;
  cfg = vars.services.backup;

  sqliteStagingDir = "/var/backup/sqlite";
  repository = "/mnt/backup/olympus";

  metricsPort = 15137;
in

{
  options.homelab.services.backup = {
    enable = lib.mkEnableOption "Enable automatic backups";

    paths = lib.mkOption {
      default = [ ];
    };

    dbFiles = lib.mkOption {
      default = { };
    };

  };

  config = lib.mkIf cfg.enable {

    sops.secrets."restic/password" = { };

    systemd.tmpfiles.rules = [
      "d ${sqliteStagingDir} 0700 root root -"
    ];

    systemd.services.prometheus-restic-exporter.serviceConfig.DynamicUser = false;

    services = {
      prometheus = {
        exporters.restic = {
          enable = true;
          inherit repository;
          port = metricsPort;
          user = "root";
          group = "root";
          listenAddress = "127.0.0.1";
          passwordFile = config.sops.secrets."restic/password".path;
          refreshInterval = 60 * 60 * 2;
        };

        scrapeConfigs = [
          {
            job_name = "restic";
            static_configs = [
              {
                targets = [ "127.0.0.1:${toString metricsPort}" ];
                labels.host = "olympus";
              }
            ];
          }
        ];
      };

      postgresqlBackup = {
        enable = true;
        backupAll = true;
        compression = "zstd";
        compressionLevel = 19;
      };

      restic.backups.olympus = {
        initialize = true;
        inherit repository;
        passwordFile = config.sops.secrets."restic/password".path;

        backupPrepareCommand = ''
          set -eu
          mkdir -p ${sqliteStagingDir}
        ''
        + lib.concatStrings (
          lib.mapAttrsToList (name: src: ''
            ${pkgs.sqlite}/bin/sqlite3 "${src}" ".backup '${sqliteStagingDir}/${name}.db'"
          '') cfg.dbFiles
        );

        paths = [
          "/var/backup/postgresql"
          sqliteStagingDir
        ]
        ++ cfg.paths;

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 6"
        ];

        timerConfig = {
          OnCalendar = "03:33";
          Persistent = true;
        };
      };
    };
  };
}
