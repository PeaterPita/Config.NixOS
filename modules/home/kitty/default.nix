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
    modules.starship.enable = true;

    programs.kitty = {
      enable = true;
      font = {

        package = lib.mkForce pkgs.monocraft;
        name = lib.mkForce "Monocraft";
      };
      shellIntegration.enableZshIntegration = true;
      themeFile = "VibrantInk";
      extraConfig = "include themes/noctalia.conf";
      keybindings = {
        "ctrl+c" = "copy_or_interrupt";

        "ctrl+shift+n" = "launch --location=split --cwd=current";

        "ctrl+shift+t" = "launch --type=tab";

        "ctrl_shift+f" = "toggle_layout stack";
        "ctrl_shift+r" = "start_resizing_window";

        "ctrl+shift+left" = "neighboring_window left";
        "ctrl+shift+right" = "neighboring_window right";
        "ctrl+shift+up" = "neighboring_window up";
        "ctrl+shift+down" = "neighboring_window down";

      }
      // builtins.listToAttrs (
        map (num: {
          name = "ctrl+shift+${toString num}";
          value = "goto_tab ${toString num}";
        }) (lib.range 1 9)
      );
      settings = {

        scrollback_lines = "-1";

        remember_window_size = "yes";
        inactive_text_alpha = "-0.4";

        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{index}: {title}";
        active_tab_title_template = ">> {index} <<";

        copy_on_select = "clipboard";
        strip_trailing_spaces = "smart";

        notify_on_cmd_finish = "unfocused";

        confirm_os_window_close = "0";
        background_opacity = "1.0";
        enabled_layouts = "splits,stack";
      };
    };
  };
}
