{ lib, ... }:

{
  options.homelab = {
    baseDomain = lib.mkOption {
      type = lib.types.str;
      default = "home.arpa";
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

    ports = {
      navidrome = lib.mkOption { default = 4533; };
      jellyfin = lib.mkOption { default = 8096; };
      authentik = lib.mkOption { default = 9000; };
      mealie = lib.mkOption { default = 9004; };
    };
  };
}
