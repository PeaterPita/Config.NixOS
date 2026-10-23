{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

###################################################################
# Mango-Flake Options: https://mangowm.github.io/docs/nix-options #
###################################################################
let
  cfg = config.modules.mango;
in
{
  options = {
    modules.mango.enable = lib.mkEnableOption "mango";
  };

  config = lib.mkIf cfg.enable {
    modules = {
      foot.enable = true;
      anyrun.enable = true;
      mako.enable = true;
      mangobar.enable = true;

      matugen = {
        enable = true;
        templates."mango" = {
          outputPath = "~/.config/mango/matugen.conf";
          reloadCmd = "mmsg dispatch reload_config";
          text = ''
            root_color={{colors.background.dark.hex_stripped}}ff
            border_color={{colors.outline_variant.dark.hex_stripped}}ff
            focus_color={{colors.primary_container.dark.hex_stripped}}ff
            maximized_screen_color={{colors.secondary.dark.hex_stripped}}ff
            urgent_color={{colors.error.dark.hex_stripped}}ff
            scratchpad_color={{colors.tertiary.dark.hex_stripped}}ff
            global_color={{colors.secondary_container.dark.hex_stripped}}ff
            overlay_color={{colors.tertiary_container.dark.hex_stripped}}ff

            jump_label_decorate_fg_color={{colors.primary.dark.hex_stripped}}ff
            jump_label_decorate_bg_color={{colors.secondary_container.dark.hex_stripped}}ff
            jump_label_decorate_focus_fg_color={{colors.on_surface.dark.hex_stripped}}ff
            jump_label_decorate_focus_bg_color={{colors.on_secondary_container.dark.hex_stripped}}ff
            jump_label_decorate_border_color={{colors.primary.dark.hex_stripped}}ff

          '';
        };
      };
    };

    home.packages = with pkgs; [

      grim
      slurp
      satty
      xclip
    ];

    wayland.windowManager.mango = {
      enable = true;
      systemd.enable = true;
      systemd.variables = [ "--all" ];

      settings = {
        source_optional = "./matugen.conf";

        exec_once = [
          "udiskie"
          "anyrun daemon"
          "waypaper --restore"
          "aperture --daemon"

          "wl-paste --type text --watch cliphist store"
          "wl-paste --type text --watch env DISPLAY=:0 xclip -selection clipboard -i"
          "wl-paste --type image --watch cliphist store"

          "discord"
          "zen-beta"

          # "xrandr --output ${osConfig.monitors.primary.name} --primary"
        ];
        sync_obj_enable = 1;
        allow_tearing = 1;

        # Layout
        circle_layout = "fair,scroller";
        drag_tile_to_tile = 1;
        edge_scroller_pointer_focus = 0;

        scratchpad = {
          cross_monitor = 1;
          width_ratio = 0.5;
          height_ratio = 0.5;
        };

        # Apperance
        blur = 1;
        blur_optimized = 1;

        border_radius = 6;
        no_border_when_single = 1;

        focused_opacity = 1.0;
        unfocused_opacity = 1.0;

        border_px = 2;
        gap_inner_horizontal = 6;
        gap_inner_vertical = 6;

        gap_outer_horizontal = 10;
        gap_outer_vertical = 10;

        shadows = 1;
        shadows_position_y = 4;
        shadows_color = "0x0000000066";

        ## Animations
        animations = 1;
        layer_animations = 1;
        layer_shadows = 1;

        tag_animation_direction = 0;
        animation_type = {
          open = "zoom";
          close = "fade";
        };

        animation_duration = {
          open = 280;
          close = 220;
          move = 250;
          tag = 300;
          focus = 0;
        };

        # Input
        mouse.accel = {
          profile = 1;
          speed = "1.0";
        };

        trackpad = {
          natural_scrolling = 1;
          disable_while_typing = 1;
        };
        bind =
          let
            # TODO: results are not actually showing immediately?
            cmd = "anyrun --plugins libstdin.so --show-results-immediately true";
            cliphist-anyrun = pkgs.writeShellApplication {
              name = "cliphist-anyrun";
              text = ''
                export CLIPHIST_PREVIEW_WIDTH=500

                cliphist_list=$(cliphist list)
                  if [ -z "$cliphist_list" ]; then
                    echo "Clipboard Empty" | ${cmd}
                    exit 0
                  fi
                  
                  item=$(echo "$cliphist_list" | ${cmd})
                  
                  if [ -n "$item" ]; then
                    echo "$item" | cliphist decode | wl-copy
                  fi
              '';
            };

            screenshot-shell = pkgs.writeShellApplication {
              name = "screenshot-shell";
              runtimeInputs = with pkgs; [
                grim
                slurp
                wl-clipboard
                satty
                wayfreeze
                libnotify
              ];
              text = ''
                filename=$(date +%Y-%m-%d_%H%M%S)
                mkdir -p ~/Pictures/Screenshots/

                wayfreeze --hide-cursor &
                pid=$!
                sleep 0.1


                if geom=$(slurp -d); then 
                    grim -g "$geom" - | tee ~/Pictures/Screenshots/"$filename.png" | wl-copy --type image/png

                    kill "$pid"


                    satty --filename ~/Pictures/Screenshots/"$filename.png" --init-tool brush --copy-command wl-copy
                    notify-send Screenshot "Screenshot Saved at: ~/Pictures/Screenshots/$filename.png" 
                fi

                kill "$pid" 2>/dev/null || true
              '';
            };

          in

          [
            # General
            "SUPER,Q,spawn,foot"
            "SUPER,E,spawn,dolphin"
            "SUPER,W,killclient"
            "SUPER,R,reload_config"

            # "SUPER,L,spawn,noctalia msg session lock"

            "SUPER,Space,spawn,anyrun"
            "SUPER,V,spawn,${cliphist-anyrun}/bin/cliphist-anyrun"

            "SUPER+SHIFT,S,spawn_shell, ${screenshot-shell}/bin/screenshot-shell"
            "SUPER,P,spawn,waypaper"

            "SUPER,F,togglemaximizescreen"
            "SUPER+SHIFT,F,togglefloating"
            "SUPER+ALT,F,togglefullscreen"

            "SUPER,C,centerwin"

            # Movement
            "SUPER,Left,focusdir,left"
            "SUPER,Right,focusdir,right"
            "SUPER,Up,focusdir,up"
            "SUPER,Down,focusdir,down"

            "SUPER+SHIFT,Left,exchange_client,left"
            "SUPER+SHIFT,Right,exchange_client,right"
            "SUPER+SHIFT,Up,exchange_client,up"
            "SUPER+SHIFT,Down,exchange_client,down"

            "SUPER,Escape,switch_layout"

            # Scratch Pads
            "ALT,D,toggle_named_scratchpad,feishin,none,feishin"
            "ALT,F,toggle_named_scratchpad,scratch-term,none,foot -a scratch-term"

            "SUPER,I,minimized"
            "SUPER+SHIFT,I,restore_minimized"
            "SUPER,O,toggle_scratchpad"

            "ALT,Tab,overcircle"
            "SUPER,Tab,togglejump"

            "SUPER+SHIFT,Z,spawn_shell, mmsg dispatch togglefloating && mmsg dispatch toggleglobal && msg dispatch toggleoverlay"

            # Audio / Special
            "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%+"
            "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%-"
            "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SINK@ toggle"
            "NONE,XF86AudioMicMute, spawn, wpctl set-mute @DEFAULT_SOURCE@ toggle"
            "NONE,XF86AudioPlay, spawn, playerctl play-pause"
            "NONE,XF86AudioNext, spawn, playerctl next"
            "NONE,XF86AudioPrev, spawn, playerctl previous"
            "NONE,XF86MonBrightnessUp, spawn,  brightnessctl s 5%+"
            "NONE,XF86MonBrightnessDown, spawn, brightnessctl s 5%-"
          ]
          ++ (builtins.concatLists (
            builtins.genList (
              i:
              let

                ws = i + 1;
                ipc = "mmsg dispatch";
              in
              [
                "SUPER,${toString ws},spawn_shell, ${ipc} focusmon,${osConfig.monitors.primary.name} && ${ipc} view,${toString ws}"
                "SUPER+SHIFT,${toString ws},spawn_shell, ${ipc} focusmon,${osConfig.monitors.primary.name} && ${ipc} tag,${toString ws}"
              ]
            ) 9
          ));

        mousebind = [
          "SUPER,btn_left,moveresize,curmove"
          "SUPER,btn_right,moveresize,curresize"
        ];

        axisbind = [
          "SUPER,UP,focusdir,left"
          "SUPER,DOWN,focusdir,right"
          "SUPER+SHIFT,UP,viewtoleft_have_client"
          "SUPER+SHIFT,DOWN,viewtoright_have_client"
        ];

        gesturebind = [
          "none,up,3,spawn,anyrun"
          "none,down,3,spawn,anyrun close"
        ];

        # Rules
        tag_rule = [
          "id:*,monitor_name:HDMI-A-1,layout_name:scroller"
        ];

        window_rule_once = [
          "monitor:HDMI-A-1,tags:1,is_open_silent:1,app_id:discord"
          "monitor:${osConfig.monitors.primary.name},tags:1,is_open_silent:1,app_id:zen-beta"

        ];

        window_rule = [
          "is_named_scratchpad:1,is_floating:1,is_overlay:1,app_id:feishin"
          "is_named_scratchpad:1,is_floating:1,width:0.8,height:0.8,app_id:scratch-term"

          "title:^(Open File|Save File)$,is_floating:1"
          "app_id:^(com.gabm.satty),is_floating:1"
          "app_id:^(org.pulseaudio.pavucontrol|org.kde.polkit-kde-authentication-agent-1),is_floating:1"

          "app_id:waypaper,is_floating:1,no_border:1,no_shadow:1,is_global:1,focused_opacity:0.8,unfocused_opacity:0.8"
          "app_id:foot,focused_opacity:0.9,unfocused_opacity:0.9"

          "app_id:Aperture,is_floating:1"
        ];

        layer_rule = [
          "layer_name:anyrun,no_animation:1, no_blur:1"
          "layer_name:selection,no_animation:1,no_blur:1"
        ];

        ## Outputs
        monitor_rule = map (
          monitor:
          let
            splitPos = lib.splitString "x" monitor.position;
            x = builtins.elemAt splitPos 0;
            y = builtins.elemAt splitPos 1;
            disable = if monitor.enabled then "0" else "1";
            primary = if monitor.primary then "1" else "0";
          in
          "name:^${monitor.name}$,primary:${primary},width:${toString monitor.width},height:${toString monitor.height},refresh:${toString monitor.refreshRate},x:${x},y:${y},scale:${toString monitor.scale},disable:${disable}"
        ) osConfig.monitors.all;

      };
    };
  };
}
