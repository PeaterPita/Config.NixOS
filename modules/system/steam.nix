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
    environment = {
      systemPackages = with pkgs; [ mangohud ];
      sessionVariables = {
        STEAM_FRAME_FORCE_CLOSE = "1";
      };
    };
    hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
  };
}
