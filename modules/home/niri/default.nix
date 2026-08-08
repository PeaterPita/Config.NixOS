{
  config,
  lib,
  osConfig,
  ...
}:

############################################################
#                     Niri-Flake Docs:                     #
# https://github.com/sodiboo/niri-flake/blob/main/kdl.nix  #
############################################################
let
  cfg = config.modules.niri;
in
{
  options = {
    modules.niri.enable = lib.mkEnableOption "niri";
  };

  config = lib.mkIf cfg.enable {
    modules = {
      noctalia.enable = true;
      kitty.enable = true;
    };

    programs.niri.settings = {
      input = {
        mouse = {
          accel-profile = "flat";
          accel-speed = 0.3;
        };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "60%";
        };
      };
      binds = {

        "Mod+Q".action.spawn = "kitty";
        "Mod+E".action.spawn = "dolphin";
        "Mod+W".action.close-window = { };
        "Mod+Escape".action.toggle-overview = { };
        "Mod+Shift+S".action.screenshot = { };

        "XF86AudioRaiseVolume".action.spawn = [
          "wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "5%+"
        ];
        "XF86AudioLowerVolume".action.spawn = [
          "wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "5%-"
        ];
        "XF86AudioMute".action.spawn = [
          "wpctl"
          "set-mute"
          "@DEFAULT_AUDIO_SINK@"
          "toggle"
        ];
        "XF86AudioMicMute".action.spawn = [
          "wpctl"
          "set-mute"
          "@DEFAULT_AUDIO_SOURCE@"
          "toggle"
        ];

        "XF86AudioPlay".action.spawn = [
          "playerctl"
          "play-pause"
        ];
        "XF86AudioNext".action.spawn = [
          "playerctl"
          "next"
        ];
        "XF86AudioPrev".action.spawn = [
          "playerctl"
          "previous"
        ];

        "XF86MonBrightnessUp".action.spawn = [
          "brightnessctl"
          "s"
          "5%+"
        ];
        "XF86MonBrightnessDown".action.spawn = [
          "brightnessctl"
          "s"
          "5%-"
        ];

        "Mod+SHIFT+W".action.spawn = [
          "pkill"
          "noctalia || noctalia"
        ];

        "Mod+L".action.spawn = [
          "noctalia"
          "msg"
          "session"
          "lock"
        ];
        "Mod+Space".action.spawn = [
          "noctalia"
          "msg"
          "panel-toggle"
          "launcher"
        ];
        "Mod+Plus".action.spawn = [
          "noctalia"
          "msg"
          "bar-toggle"
        ];
        "Mod+TAB".action.spawn = [
          "noctalia"
          "msg"
          "window-switcher"
        ];

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;

        "Mod+F".action.maximize-column = { };
        "Mod+Shift+F".action.toggle-window-floating = { };

        "Mod+Shift+Left".action.move-column-left = { };
        "Mod+Shift+Right".action.move-column-right = { };
        "Mod+Shift+Up".action.move-window-up = { };
        "Mod+Shift+Down".action.move-window-down = { };

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";

        "Mod+Left".action.focus-column-left = { };
        "Mod+Right".action.focus-column-right = { };
        "Mod+Up".action.focus-workspace-up = { };
        "Mod+Down".action.focus-workspace-down = { };
        "Mod+C".action.center-column = { };

        "Mod+WheelScrollDown".action.focus-column-left = { };
        "Mod+WheelScrollUp".action.focus-column-right = { };
        "Mod+Shift+WheelScrollDown".action.focus-workspace-down = { };
        "Mod+Shift+WheelScrollUp".action.focus-workspace-up = { };

      };

      layout = {
        gaps = 5;
        center-focused-column = "never";

        default-column-width = {
          proportion = 0.5;
        };
        border = {
          enable = true;
          width = 4;
          active.color = "#8F3985";
          inactive.color = "#313244";
        };

        focus-ring.enable = false;
      };

      animations =
        let
          stiff-spring = {
            damping-ratio = 1.0;
            stiffness = 1000;
            epsilon = 0.001;
          };
        in
        {
          workspace-switch.kind.spring = stiff-spring;
          window-open.kind.spring = stiff-spring;
          window-close.kind.spring = stiff-spring;
        };

      window-rules = [
        {
          matches = [
            { app-id = "^(pavucontrol|nm-connection-editor|blueman-manager)$"; }
            { title = "^(Open File|Save As|Polkit|Authentication Required)$"; }
          ];
          open-floating = true;
        }
      ];

      spawn-at-startup = [
        { argv = [ "udiskie" ]; }
        { argv = [ "noctalia" ]; }
      ];

      hotkey-overlay.skip-at-startup = true;

      outputs = builtins.listToAttrs (
        map (monitor: {
          inherit (monitor) name;
          value = {
            enable = monitor.enabled;
            focus-at-startup = monitor.primary or false;
            scale = lib.toInt monitor.scale;
            mode = {
              inherit (monitor) height width;
              refresh = 1.0 * monitor.refreshRate;
            };
            position =
              let
                split = lib.splitString "x" monitor.position;
              in
              {
                x = lib.toInt (builtins.elemAt split 0);
                y = lib.toInt (builtins.elemAt split 1);
              };
          };
        }) osConfig.monitors
      );

    };

  };
}
