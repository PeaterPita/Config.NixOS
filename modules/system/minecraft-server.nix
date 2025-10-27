{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.minecraft-server;
in
{
  options = {
    modules.minecraft-server.enable = lib.mkEnableOption "minecraft-server";
  };

  config = lib.mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      openFirewall = true;
      eula = true;
      declarative = true;
      package = pkgs.papermcServers.papermc-1_21_4;

      serverProperties = {
        server-port = 44330;
        motd = "NixOS Testing Minecraft server";
        allow-cheats = true;
      };
      jvmOpts = "-Xms2048M -Xmx4096M";
    };
  };
}
