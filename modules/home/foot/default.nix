{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.foot;
in
{
  options = {
    modules.foot.enable = lib.mkEnableOption "foot";
  };

  config = lib.mkIf cfg.enable {
    modules.starship.enable = true;
    home.packages = [ pkgs.monocraft ];

    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "monocraft:size=12";
          include = "${config.xdg.configHome}/foot/themes/noctalia";
        };
        scrollback.lines = 99999;
        mouse.hide-when-typing = "yes";

        # colors-dark.alpha = 0.9;

      };

    };

    #   shellIntegration.enableZshIntegration = true;
    #   extraConfig = "include themes/noctalia.conf";
    #   keybindings = {
    #     "ctrl+c" = "copy_or_interrupt";
    #
    #   };
    #   settings = {
    #     copy_on_select = "clipboard";
    #     strip_trailing_spaces = "smart";
    #
    #     confirm_os_window_close = "0";
    #   };
    # };
  };
}
