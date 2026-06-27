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

    sops.secrets."restic/password" = {
      sopsFile = ../../../secrets/services.yaml;
    };

    systemd.tmpfiles.rules = [
      "d ${sqliteStagingDir} 0700 root root -"
    ];

    services.postgresqlBackup = {
      enable = true;
      backupAll = true;
      compression = "zstd";
      compressionLevel = 19;
    };

    services.restic.backups.olympus = {
      initialize = true;
      repository = "/mnt/backup/olympus";
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
}
