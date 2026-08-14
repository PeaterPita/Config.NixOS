{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.samba;

  shareSubmodule = lib.types.submodule {
    options = {
      path = lib.mkOption {
        type = lib.types.str;
      };
      readOnly = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      public = lib.mkOption {
        type = lib.types.bool;
        default = false;

      };
      validUsers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "peaterpita" ];
      };
    };
  };

in

{
  options.homelab.services.samba = {
    enable = lib.mkEnableOption "Samba file share";
    shares = lib.mkOption {
      type = lib.types.attrsOf shareSubmodule;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      samba = {
        enable = true;
        smbd.enable = true;
        openFirewall = true;
        settings = {
          global = {
            workgroup = "WORKGROUP";
            "server string" = "Olympus";
            "netbios name" = "olympus";
            security = "user";
            "hosts allow" = "192.168.0.0/24 100.64.0.0/10 127.0.0.1";
            "hosts deny" = "0.0.0.0/0";
            "map to guest" = "Bad User";
          };
        }
        // lib.mapAttrs (
          _: shareCfg:
          {
            "path" = shareCfg.path;
            "read only" = if shareCfg.readOnly then "yes" else "no";
            "browseable" = "yes";
            "guest ok" = if shareCfg.public then "yes" else "no";
            "create mask" = if shareCfg.public then "0666" else "0664";
            "directory mask" = if shareCfg.public then "0777" else "0775";
            "force create mode" = if shareCfg.public then "0666" else "0000";
            "force directory mode" = if shareCfg.public then "0777" else "0000";
          }
          // lib.optionalAttrs shareCfg.public {
            "force user" = "nobody";
            "force group" = "nobody";
          }
          // lib.optionalAttrs (!shareCfg.public) {
            "valid users" = lib.concatStringsSep " " shareCfg.validUsers;
          }
        ) cfg.shares;
      };
      avahi = {
        publish.enable = true;
        publish.userServices = true;
        nssmdns4 = true;
        enable = true;
        openFirewall = true;
      };
      samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
