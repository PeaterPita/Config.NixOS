{ lib, ... }:

{
  options.homelab = {
    baseDomain = lib.mkOption {
      type = lib.types.str;
      default = "peaterpita.com";
      description = "Internal domain for LAN + Tailscale access";
    };

    ingressIP = lib.mkOption {
      type = lib.types.str;
      default = "192.168.0.201";
      description = "IP of Hermes";
    };

    coreIP = lib.mkOption {
      type = lib.types.str;
      default = "192.168.0.200";
      description = "IP of Olympus";
    };
  };
}
