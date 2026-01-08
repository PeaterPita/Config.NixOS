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
    environment.systemPackages = with pkgs; [ mangohud ];
    hardware.steam-hardware.enable = true;
    programs = {
      steam.enable = true;
      gamemode.enable = true;
      gamescope.enable = true;
    };
  };
}
