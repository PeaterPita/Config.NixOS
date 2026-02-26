{ lib, ... }:

{
  options.homelab = {
    baseDomain = lib.mkOption {
      type = lib.types.str;
      default = "home.arpa";
      description = "Base of homelab domain"; # To be changed
    };

    storageIP = lib.mkOption {
      type = lib.types.str;
      description = "ip address of the storage vm";
      default = "192.168.0.134";
    };

    ingressip = lib.mkOption {
      type = lib.types.str;
      description = "ip address of ingress (virtual) machine";
      default = "192.168.0.135";
    };

    coreIP = lib.mkOption {
      type = lib.types.str;
      description = "IP address of core services (virtual) machine";
      default = "192.168.0.136";
    };

    gameIP = lib.mkOption {
      type = lib.types.str;
      description = "IP address of the gameserver machine";
      default = "192.168.X.X";
    };
  };

}
