{
  config,
  inputs,
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

  imports = [
    inputs.disko.nixosModules.disko
  ];

  config = lib.mkIf cfg.enable {

    # disko.devices.zpool.tank.datasets."nextcloud" = {
    #   type = "zfs_fs";
    #   mountpoint = "/mnt/nextcloud";
    # };

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
          href = "http://nextcloud.${vars.baseDomain}";
          description = "Personal Cloud Storage";
          ping = "http://nextcloud.${vars.baseDomain}";
        };
      }
    ];

    services.redis.servers.nextcloud.enable = true;

    services.nextcloud = {
      enable = true;
      hostName = "nextcloud.${vars.baseDomain}";

      configureRedis = true;
      datadir = "/mnt/nextcloud";
      config = {
        dbtype = "pgsql";
        dbname = "nextcloud";
        dbuser = "nextcloud";
        adminpassFile = "/home/peaterpita/nixos/secrets/nextcloud-admin-pass";
      };
    };
  };

}
