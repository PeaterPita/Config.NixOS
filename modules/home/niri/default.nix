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
      waybar.enable = true;
    };

    home.packages = with pkgs; [
      grimblast
    ];

    programs.swaylock = {
      enable = true;
      settings = {
        color = "1e1e2e";
        indicator-radius = 100;
        indicator-thickness = 7;
        ring-color = "7fc8ff";
        inside-color = "1e1e2ecc";
        line-color = "00000000";
        key-hl-color = "7fc8ff";
        text-color = "cdd6f4";
        ring-ver-color = "a6e3a1";
        ring-wrong-color = "f38ba8";
        inside-ver-color = "1e1e2ecc";
        inside-wrong-color = "1e1e2ecc";
        text-ver-color = "a6e3a1";
        text-wrong-color = "f38ba8";
        show-failed-attempts = true;
      };
    };

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

        workspaces = [
          "term"
          "main"
          "3"
          "4"
          "5"
          "6"
          "7"
          "8"
          "9"
        ];

        workspaceBinds = lib.concatStringsSep "\n" (
          lib.imap1 (
            i: name:
            let
              ws = toString i;
            in
            ''
              Mod+${ws} { focus-workspace ${ws}; }
              Mod+Shift+${ws} { move-window-to-workspace ${ws}; }
            ''
          ) workspaces
        );

      in
      ''
        input {
            disable-power-key-handling
            keyboard {
                xkb {
                    layout "us,gb"
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

            // focus-ring {
            //     width 2
            //    active-color "#7fc8ff"
            //     inactive-color "#505050"
            //
            // }

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
        screenshot-path "~/Pictures/Screenshots/Screenshot %Y-%m-%d %H-%M-%S.png"

        window-rule {
            match title="Picture in picture"
            open-floating true
            default-floating-position x=100 y=100 relative-to="bottom-right"
            tiled-state true
        }

        window-rule {
            match app-id=r#"kitty"#
            open-maximized true
            open-on-workspace "term"
        }


        window-rule {
            match app-id=r#"firefox"#
            open-on-workspace "main"
        }

        window-rule {
            match app-id=r#"obsidian"#
            open-on-workspace "main"
        }

        window-rule {
            geometry-corner-radius 6
            clip-to-geometry true
        }


        spawn-at-startup "qs"
        spawn-at-startup "swww-daemon"
        spawn-at-startup "obsidian"
        spawn-at-startup "firefox"

        binds {

            ${workspaceBinds}
            Mod+Shift+Slash { show-hotkey-overlay; }
            Mod+Shift+O hotkey-overlay-title="toggle opacity" { toggle-window-rule-opacity; }

            Mod+Shift+W hotkey-overlay-title="toggle bar" repeat=false { spawn-sh "pkill -SIGUSR1 qs || qs"; }

            Mod+Q hotkey-overlay-title="Open a Terminal " { spawn "kitty"; }
            Mod+O hotkey-overlay-title="Open a Obsidian " { spawn "obsidian"; }
            Mod+E hotkey-overlay-title="Open a FileManager " { spawn "files"; }
            Mod+Space hotkey-overlay-title="Run an Application" { spawn-sh "fuzzel"; }
            Super+Shift+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn-sh "swaylock "; }

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


            Mod+Shift+Left  { move-column-left; }
            Mod+Shift+Right { move-column-right; }
            Mod+Alt+Down    { move-window-down; }
            Mod+Alt+Up      { move-window-up; }

            Mod+Shift+Down { move-column-to-workspace-down; }
            Mod+Shift+Up   { move-column-to-workspace-up; }

            Mod+Ctrl+Left  { set-column-width "-10%"; }
            Mod+Ctrl+Right { set-column-width "+10%"; }
            Mod+Ctrl+Up    { set-window-height "-10%"; }
            Mod+Ctrl+Down  { set-window-height "+10%"; }


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

            Mod+R { switch-preset-column-width; }
            Mod+Shift+R { switch-preset-window-height; }
            Mod+Ctrl+R { reset-window-height; }
            Mod+F { maximize-column; }
            Mod+Shift+F { fullscreen-window; }

            Mod+Ctrl+F { expand-column-to-available-width; }

            Mod+C { center-column; }

            Mod+Ctrl+C { center-visible-columns; }

            Mod+V       { toggle-window-floating; }
            Mod+Shift+V { switch-focus-between-floating-and-tiling; }



            Mod+Shift+S { screenshot; }
            Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        }
        layer-rule {
            place-within-backdrop true
        }
      '';
  };
}
