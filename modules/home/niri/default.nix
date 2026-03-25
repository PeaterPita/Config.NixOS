{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  cfg = config.modules.niri;
in
{
  options.modules.niri.enable = lib.mkEnableOption "niri";

  config = lib.mkIf cfg.enable {
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    services.network-manager-applet.enable = true;

    modules = {
      fuzzel.enable = true;
      swaync.enable = true;
      theme.enable = true;
      nemo.enable = true;
    };

    home.packages = with pkgs; [
      ffmpeg
      grimblast
    ];

    programs.swaylock.enable = true;

    services.swayidle = {
      enable = true;
      events = [
        {
          event = "lock";
          command = "${pkgs.swaylock}/bin/swaylock -f";
        }
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -f";
        }
      ];
    };

    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "${pkgs.swaylock}/bin/swaylock -f";
          text = "Lock";
        }
        {
          label = "logout";
          action = "niri msg action quit";
          text = "Logout";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
        }
      ];
    };

    #####################################################################################
    #                        Current boiler plate stolen from:                          #
    # https://github.com/JotaFab/s13los/blob/main/modules/home/programs/niri/config.kdl #
    #####################################################################################

    xdg.configFile."niri/config.kdl".text =
      let
        monitorsText = lib.concatStringsSep "\n" (
          map (monitor: ''
            output "${monitor.name}" {
                mode "${toString monitor.width}x${toString monitor.height}@${toString monitor.refreshRate}"
                scale ${toString monitor.scale}
            }
          '') osConfig.monitors
        );

        workspaceBinds = lib.concatStringsSep "\n" (
          builtins.genList (
            i:
            let
              ws = toString (i + 1);
            in
            ''
              Mod+${ws} { focus-workspace ${ws}; }
              Mod+Shift+${ws} { move-window-to-workspace ${ws}; }
            ''
          ) 9
        );

      in

      ''
        input {
            keyboard {
                xkb {
                    layout "us,es"
                    options "grp:win_space_toggle,compose:ralt,ctrl:nocaps"
                }
                numlock
            }
            touchpad {
                tap
                natural-scroll
            }

            mouse {
                natural-scroll
            }

        }
        ${monitorsText}
        overview {
            zoom 0.25
        }

        layout {
            gaps 5
            center-focused-column "on-overflow"
            always-center-single-column

            focus-ring {
                width 2
                active-color "#7fc8ff"
                inactive-color "#505050"

            }

            border {
                off
                width 2
                active-color "#ffc87f"
                inactive-color "#505050"

                urgent-color "#9b0000"

            }

            shadow {
                on

                draw-behind-window true

                softness 50

                spread 5

                offset x=0 y=5

                color "#0007"
            }
            background-color "transparent"

        }
        hotkey-overlay {
            skip-at-startup
        }
        screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
        animations {
            // off
            }


        window-rule {
            match app-id=r#"^org\.wezfurlong\.wezterm$"#
            default-column-width {}
        }

        window-rule {
            match title="Picture in picture"
            open-floating true
            default-floating-position x=100 y=100 relative-to="bottom-right"
            tiled-state true
        }

        workspace "1"
        workspace "brow"
        workspace "term"
        workspace "4"
        workspace "5"
        workspace "6"
        workspace "7"
        workspace "obs"
        workspace "oss"

        window-rule {
            match app-id=r#"obs"#
            open-on-workspace "obs"
        }
        window-rule {
            match app-id=r#"steam"#
            open-on-workspace "oss"
        }
        window-rule {
            match app-id=r#"^Spotify$"#
            open-on-workspace "oss"
        }
        window-rule {
            match app-id=r#"^discord$"#
            open-on-workspace "oss"
        }
        window-rule {
            match app-id=r#"chromium"#
            open-maximized true
            open-on-workspace "brow"
        }
        window-rule {
            match app-id=r#"ghostty"#
            open-maximized true
            opacity 0.65
            open-on-workspace "term"
        }

        window-rule {
            match app-id=r#"qemu"#
            open-on-workspace "5"
            open-maximized true
        }

        /-window-rule {
            match app-id=r#"^org\.keepassxc\.KeePassXC$"#
            match app-id=r#"^org\.gnome\.World\.Secrets$"#

            block-out-from "screen-capture"
        }

        window-rule {
            geometry-corner-radius 6
            clip-to-geometry true
        }


        // This line starts waybar, a commonly used bar for Wayland compositors.
        spawn-at-startup "qs"
        spawn-at-startup "obsidian"
        spawn-at-startup "firefox"
        spawn-sh-at-startup "swayidle -w timeout 600 'swaylock -f' timeout 900 'niri msg output power off' resume 'niri msg output power on' before-sleep 'swaylock -f'"

        binds {

            ${workspaceBinds}
            Mod+Shift+Slash { show-hotkey-overlay; }
            Mod+Shift+O hotkey-overlay-title="toggle opacity" { toggle-window-rule-opacity; }

            Mod+Shift+W hotkey-overlay-title="toggle waybar" repeat=false { spawn-sh "pkill -SIGUSR1 qs || qs"; }

            Mod+Q hotkey-overlay-title="Open a Terminal " { spawn "kitty"; }
            Mod+O hotkey-overlay-title="Open a Obsidian " { spawn "obsidian"; }
            Mod+E hotkey-overlay-title="Open a FileManager " { spawn "files"; }
            Mod+D hotkey-overlay-title="Run an Application" { spawn-sh "wofi --show drun"; }
            Super+Shift+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn-sh "swaylock "; }
            Super+Alt+S allow-when-locked=true hotkey-overlay-title=null { spawn-sh "pkill orca || exec orca"; }

            XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"; }
            XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"; }
            XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
            XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

            XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
            XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }
            XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
            XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }

            XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
            XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

            Mod+TAB repeat=false { toggle-overview; }

            Mod+W repeat=false { close-window; }

            Mod+Left  { focus-column-left; }
            Mod+Down  { focus-window-or-workspace-down; }
            Mod+Up    { focus-window-or-workspace-up; }
            Mod+Right { focus-column-right; }
            Mod+H     { focus-column-left; }
            Mod+L     { focus-column-right; }

            Mod+Ctrl+Left  { move-column-left; }
            Mod+Ctrl+Down  { move-window-down; }
            Mod+Ctrl+Up    { move-window-up; }
            Mod+Ctrl+Right { move-column-right; }
            Mod+Ctrl+H     { move-column-left; }
            Mod+Ctrl+L     { move-column-right; }

            Mod+J     { focus-window-or-workspace-down; }
            Mod+K     { focus-window-or-workspace-up; }
            Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
            Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }

            Mod+Home { focus-column-first; }
            Mod+End  { focus-column-last; }
            Mod+Ctrl+Home { move-column-to-first; }
            Mod+Ctrl+End  { move-column-to-last; }



            Mod+Page_Down      { focus-workspace-down; }
            Mod+Page_Up        { focus-workspace-up; }
            Mod+U              { focus-workspace-down; }
            Mod+I              { focus-workspace-up; }
            Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
            Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
            Mod+Ctrl+U         { move-column-to-workspace-down; }
            Mod+Ctrl+I         { move-column-to-workspace-up; }


            Mod+Shift+Page_Down { move-workspace-down; }
            Mod+Shift+Page_Up   { move-workspace-up; }
            Mod+Shift+U         { move-workspace-down; }
            Mod+Shift+I         { move-workspace-up; }

            Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
            Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
            Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
            Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

            Mod+WheelScrollRight      { focus-column-right; }
            Mod+WheelScrollLeft       { focus-column-left; }
            Mod+Ctrl+WheelScrollRight { move-column-right; }
            Mod+Ctrl+WheelScrollLeft  { move-column-left; }

            Mod+Shift+WheelScrollDown      { focus-column-right; }
            Mod+Shift+WheelScrollUp        { focus-column-left; }
            Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
            Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }


            Mod+BracketLeft  { consume-or-expel-window-left; }
            Mod+BracketRight { consume-or-expel-window-right; }

            Mod+Comma  { consume-window-into-column; }
            Mod+Period { expel-window-from-column; }

            Mod+R { switch-preset-column-width; }
            Mod+Shift+R { switch-preset-window-height; }
            Mod+Ctrl+R { reset-window-height; }
            Mod+F { maximize-column; }
            Mod+Shift+F { fullscreen-window; }

            Mod+Ctrl+F { expand-column-to-available-width; }

            Mod+C { center-column; }

            Mod+Ctrl+C { center-visible-columns; }

            Mod+Minus { set-column-width "-10%"; }
            Mod+Equal { set-column-width "+10%"; }

            Mod+Shift+Minus { set-window-height "-10%"; }
            Mod+Shift+Equal { set-window-height "+10%"; }

            Mod+V       { toggle-window-floating; }
            Mod+Shift+V { switch-focus-between-floating-and-tiling; }



            Print { screenshot; }
            Ctrl+Print { screenshot-screen; }
            Alt+Print { screenshot-window; }

            Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

            Mod+Shift+E { quit; }
            Ctrl+Alt+Delete { quit; }

            Mod+Shift+P { power-off-monitors; }
        }
        layer-rule {
            place-within-backdrop true
        }






      '';
  };
}
