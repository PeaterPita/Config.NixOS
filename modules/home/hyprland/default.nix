{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  cfg = config.modules.hyprland;
  primary = builtins.head (builtins.filter (monitor: monitor.primary) osConfig.monitors);
in
{
  options = {
    modules.hyprland.enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
    modules = {
      noctalia.enable = true;
      kitty.enable = true;
    };
    home.packages = with pkgs; [
      ffmpeg
      kdePackages.dolphin
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = false;
      configType = "hyprlang";
      settings = {
        "$mod" = "SUPER";

        exec-once = [
          "hyprctl dispatch focusmonitor ${primary.name}"
          "xrandr --output ${primary.name} --primary"
          "udiskie"
          "noctalia"
        ];

        source = [ "~/.config/hypr/noctalia.conf" ];

        general = {
          gaps_out = 0;
          gaps_in = 0;
        };

        animation = [ "global, 0" ];

        windowrule = [
          "match:class ^(pavucontrol|org.kde.polkit-kde-authentication-agent-1)$, float yes"
          "match:title ^(Open File|Save File)$, float yes"
          "match:class ^(com.gabm.satty), float yes"
        ];

        input = {
          kb_layout = "us";
          accel_profile = "flat";
        };

        workspace =
          let
            nonPrimary = builtins.filter (monitor: !monitor.primary) osConfig.monitors;
          in

          builtins.genList (
            i:
            let
              idx = i + 1;
            in
            "${toString idx}, monitor:${primary.name}"
            + (if idx == 1 then ",default:true" else "")
            + (if idx <= 3 then ",persistent:true" else "")
          ) 9
          ++ (map (
            monitor: "name:${monitor.name}, monitor:${monitor.name}, default:true, persistent:true"
          ) nonPrimary);

        monitor = [
          ", preferred, auto, 1"
        ]
        ++ (map (
          m:
          "${m.name}, ${
            if m.enabled then
              "${toString m.width}x${toString m.height}@${toString m.refreshRate},${m.position},${m.scale}"
            else
              "disable"
          }"
        ) (osConfig.monitors));

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

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

        bind = [
          "$mod, W, killactive"
          "$mod, F, fullscreen"
          "$mod SHIFT, F, togglefloating"

          "$mod, Left, movefocus, l"
          "$mod, Right, movefocus, r"
          "$mod, Up, movefocus, u"
          "$mod, Down, movefocus, d"

          "$mod SHIFT, left,  resizeactive, -100 0"
          "$mod SHIFT, right, resizeactive, 100 0"
          "$mod SHIFT, up,    resizeactive, 0 -100"
          "$mod SHIFT, down,  resizeactive, 0 100"

          "$mod, Q, exec, kitty"
          "$mod, E, exec, dolphin"

          "$mod SHIFT, S, exec, noctalia msg screenshot-region"
          "$mod, L, exec, noctalia msg session lock"
          "$mod, Space, exec, noctalia msg panel-toggle launcher"
          "$mod SHIFT, W, exec, pkill noctalia || noctalia "
          "$mod, Plus, exec, noctalia msg bar-toggle"
          "$mod, TAB, exec, noctalia msg window-switcher"

        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        ));
      };
    };
  };

}
