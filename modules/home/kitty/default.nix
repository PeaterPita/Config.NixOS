{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.kitty;
in
{
  options = {
    modules.kitty.enable = lib.mkEnableOption "kitty";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {

        package = pkgs.monocraft;
        name = "Monocraft";
      };
      shellIntegration.enableZshIntegration = true;
      themeFile = "VibrantInk";
      settings = {
        confirm_os_window_close = "0";
        map = "ctrl+c copy_or_interrupt";
      };
    };
  };
}
