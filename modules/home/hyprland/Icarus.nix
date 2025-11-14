{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  host = osConfig.networking.hostName;
  hyprEnabled = config.modules.hyprland.enable;
in
{
  config = lib.mkIf (hyprEnabled && host == "Icarus") {
    wayland.windowManager.hyprland.settings = {
      input = {

        touchpad = {
          natural_scroll = "yes";
          disable_while_typing = true;
          clickfinger_behavior = false;
          scroll_factor = "0.5";
        };

        accel_profile = "flat";

        animation = [ "global, 0" ];

      };
      binde = [
        " ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        " ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        " ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        " ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        " ,XF86AudioPlay, exec, playerctl play-pause"
        " ,XF86AudioNext, exec, playerctl next"
        " ,XF86AudioPrev, exec, playerctl previous"

        " ,XF86MonBrightnessUp, exec,  brightnessctl s 5%+"
        " ,XF86MonBrightnessDown, exec, brightnessctl s 5%-"

      ];
    };
  };
}
