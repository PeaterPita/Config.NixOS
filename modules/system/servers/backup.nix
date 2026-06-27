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
      compression = "gzip";
      compressionLevel = 9;
    };

    services.restic.backups.olympus = {
      initialize = true;
      repository = "/mnt/backup/olympus";
      passwordFile = config.sops.secrets."restic/password".path;

      backupPrepareCommand = ''
        set -eu
        mkdir -p ${sqliteStagingDir}
      ''
      + lib.optionalString vars.services.mealie.enable ''
        ${pkgs.sqlite}/bin/sqlite3 "/var/lib/mealie/mealie.db" ".backup '${sqliteStagingDir}/mealie.db'"
      '';

      paths = [
        "/var/backup/postgresql"
        sqliteStagingDir
      ]
      ++ lib.optional vars.services.immich.enable "/mnt/immich/upload"
      ++ lib.optional vars.services.filebrowser-quantum.enable "/mnt/files"
      ++ lib.optional vars.services.mealie.enable "/var/lib/mealie/recipes"
      ++ lib.optional vars.services.paperless-ngx.enable "/var/lib/paperless";

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
