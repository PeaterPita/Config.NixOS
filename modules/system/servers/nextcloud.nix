{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.nextcloud;
  vars = config.homelab;

in

{
  options.homelab.services.nextcloud = {
    enable = lib.mkEnableOption "Enable the Nextcloud file storage service";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 ];

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [
        {
          name = "nextcloud";
          ensureDBOwnership = true;
        }
      ];
    };

    homelab.services.homepage.groups."Core" = [
      {
        Nextcloud = {
          icon = "nextcloud.png";
          href = "https://nextcloud.${vars.baseDomain}";
          description = "Personal Cloud Storage";
          ping = "https://nextcloud.${vars.baseDomain}";
        };
      }
    ];

    services.redis.servers.nextcloud.enable = true;

    services.nextcloud = {
      enable = true;
      hostName = "nextcloud.${vars.baseDomain}";

      configureRedis = true;
      datadir = "/mnt/media/nextcloud-data";
      config = {
        dbtype = "pgsql";
        dbname = "nextcloud";
        dbuser = "nextcloud";
        adminpassFile = "/home/peaterpita/nixos/secrets/nextcloud-admin-pass";
      };
    };
  };

}
