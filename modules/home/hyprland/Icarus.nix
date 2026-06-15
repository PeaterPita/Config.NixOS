{
  config,
  lib,
  ...
}:
let
  hyprEnabled = config.modules.hyprland.enable;
in
{
  config = lib.mkIf hyprEnabled {
    wayland.windowManager.hyprland.settings = {
      input = {
        touchpad = {
          natural_scroll = "yes";
          disable_while_typing = true;
          clickfinger_behavior = false;
          scroll_factor = "0.5";
        };
        accel_profile = "flat";
      };

      animations = [ "global, 0" ];
    };
  };
}
