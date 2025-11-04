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
    home.packages = with pkgs; [ putty ];
    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      themeFile = "VibrantInk";
      settings = {
        confirm_os_window_close = "0";
        map = "ctrl+c copy_or_interrupt";
      };
    };
  };
}
