{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.samba;
  vars = config.homelab;

  shareSubmodule = lib.types.submodule {
    options = {
      path = lib.mkOption {
        type = lib.types.str;
      };
      readOnly = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      comment = lib.mkOption {
        type = lib.types.str;
        default = "";
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
    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          workgroup = "WORKGROUP";
          "server string" = "Olympus";
          "netbios name" = "olympus";
          security = "user";
          "hosts allow" = "192.168.0.0/24 100.64.0.0/10 127.0.0.1";
          "hosts deny" = "0.0.0.0/0";
          "map to guest" = "never";
        };
      }
      // lib.mapAttrs (name: shareCfg: {
        path = shareCfg.path;
        "read only" = if shareCfg.readOnly then "yes" else "no";
        browseable = "yes";
        comment = shareCfg.comment;
        "valid users" = lib.concatStringsSep " " shareCfg.validUsers;
        "create mask" = "0664";
        "directory mask" = "0775";
      }) cfg.shares;
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    homelab.services.homepage.groups."Infrastructure" = [
      {
        "File Shares" = {
          icon = "samba.png";
          href = "smb://olympus";
          description = "SMB shares";
        };
      }
    ];
  };
}
