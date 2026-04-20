{
  config,
  inputs,
  lib,
  ...
}:

let
  cfg = config.homelab.services.mealie;
  vars = config.homelab;
in

{
  options.homelab.services.mealie = {
    enable = lib.mkEnableOption "Enable the Mealie recipe storage and sharing platform";
    port = lib.mkOption { default = 9004; };
  };

  imports = [

    inputs.disko.nixosModules.disko

  ];

  config = lib.mkIf cfg.enable {

    homelab.services.homepage.groups."Media" = [
      {
        Mealie = {
          icon = "mealie.png";
          href = "http://mealie.${vars.baseDomain}";
          ping = "http://127.0.0.1:${builtins.toString cfg.port}";
        };
      }
    ];

    # disko.devices.zpool.tank.datasets."mealie" = {
    #   type = "zfs_fs";
    #   mountpoint = "/mnt/mealie";
    # };

    # fileSystems."/var/lib/mealie" = {
    #   device = "/mnt/mealie";
    #   options = [ "bind" ];
    #   depends = [ "/mnt/mealie" ];
    # };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "mealie" ];
      ensureUsers = [
        {
          name = "mealie";
          ensureDBOwnership = true;
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.mealie = {
      enable = true;
      port = cfg.port;
      settings = {
        DB_ENGINE = "postgres";
        POSTGRES_SERVER = "127.0.0.1";
        POSTGRES_USER = "mealie";
        POSTGRES_DB = "mealie";

        TZ = "GMT";
      };
    };
  };

}
