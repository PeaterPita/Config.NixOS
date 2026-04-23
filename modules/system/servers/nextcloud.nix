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
    port = lib.mkOption { default = 80; };
    domain = lib.mkOption { default = "files.${vars.baseDomain}"; };
  };

  imports = [
    inputs.disko.nixosModules.disko
  ];

  config = lib.mkIf cfg.enable {

    # disko.devices.zpool.tank.datasets."nextcloud" = {
    #   type = "zfs_fs";
    #   mountpoint = "/mnt/nextcloud";
    # };

    networking.firewall.allowedTCPPorts = [ cfg.port ];

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

    homelab.services.homepage.disks = [ "/mnt/nextcloud" ];

    homelab.services.homepage.groups."Tools" = [
      {
        Nextcloud = {
          icon = "nextcloud.png";
          href = "http://${cfg.domain}";
          description = "Personal Cloud Storage";
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
        # adminpassFile = "/home/peaterpita/nixos/secrets/nextcloud-admin-pass";
      };
    };
  };

}
