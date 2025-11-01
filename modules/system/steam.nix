{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.steam;
in
{
  options = {
    modules.steam.enable = lib.mkEnableOption "steam";
  };

  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;
    hardware.steam-hardware.enable = true;
    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
  };
}
