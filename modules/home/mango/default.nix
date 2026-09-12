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
      noctalia.enable = true;
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
            rootcolor={{colors.background.dark.hex_stripped}}ff
            bordercolor={{colors.outline_variant.dark.hex_stripped}}ff
            focuscolor={{colors.primary_container.dark.hex_stripped}}ff
            maximizescreencolor={{colors.secondary.dark.hex_stripped}}ff
            urgentcolor={{colors.error.dark.hex_stripped}}ff
            scratchpadcolor={{colors.tertiary.dark.hex_stripped}}ff
            globalcolor={{colors.secondary_container.dark.hex_stripped}}ff
            overlaycolor={{colors.tertiary_container.dark.hex_stripped}}ff
            jump_hit_fg_color={{colors.on_secondary_container.dark.hex_stripped}}ff
            jump_hit_bg_color={{colors.on_surface.dark.hex_stripped}}ff
            jump_hit_border_color={{colors.primary.dark.hex_stripped}}ff
          '';
        };
      };
    };

    home.packages = with pkgs; [

      grim
      slurp
      satty
    ];

    wayland.windowManager.mango = {
      enable = true;
      settings = {
        source-optional = "./matugen.conf";

        exec-once = [
          "udiskie"
          "anyrun daemon"
          "waypaper --restore"
          "mangobar"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"

          "xrandr --output ${osConfig.monitors.primary.name} --primary"
        ];
        syncobj_enable = 1;
        xwayland_persistence = 0;

        # Layout
        circle_layout = "tile,scroller";
        drag_tile_to_tile = 1;
        edge_scroller_pointer_focus = 0;

        scratchpad = {
          cross_monitor = 1;
          width_ratio = 0.5;
          height_ratio = 0.5;
        };

        # Apperance
        blur = 1;
        blur_optimized = 0;

        border_radius = 6;
        no_border_when_single = 1;

        focused_opacity = 1.0;
        unfocused_opacity = 1.0;

        borderpx = 2;
        gappih = 6;
        gappiv = 6;

        gappoh = 10;
        gappov = 10;

        shadows = 1;
        shadows_position_y = 4;
        shadowscolor = "0x0000000066";

        ## Animations
        animations = 1;
        layer_animations = 1;
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

            "SUPER,L,spawn,noctalia msg session lock"

            "SUPER,Space,spawn,anyrun"
            "SUPER,V,spawn,${cliphist-anyrun}/bin/cliphist-anyrun"

            "SUPER+SHIFT,S,spawn_shell, ${screenshot-shell}/bin/screenshot-shell"
            "SUPER,P,spawn,waypaper"

            "SUPER+SHIFT,F,togglefloating"
            "SUPER,F,togglemaximizescreen"
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
            "ALT,F,toggle_named_scratchpad,none,scratch-term,foot -T scratch-term"

            "SUPER,I,minimized"
            "SUPER+SHIFT,I,restore_minimized"
            "SUPER,Tab,toggle_scratchpad"

            # Audio / Special
            "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%+"
            "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT__SINK@ 5%-"
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

        # Rules
        tagrule = [
          "id:*,monitor_name:HDMI-A-1,layout_name:scroller"
        ];

        windowrule = [
          "isnamedscratchpad:1,isfloating:1,appid:feishin"
          "isnamedscratchpad:1,isfloating:1,width:0.8,height:0.8,title:scratch-term"
          "title:^(Open File|Save File)$,isfloating:1"
          "appid:^(com.gabm.satty),isfloating:1"
          "appid:^(org.pulseaudio.pavucontrol|org.kde.polkit-kde-authentication-agent-1),isfloating:1"

          "appid:waypaper,isfloating:1,isnoborder:1,isnoshadow:1,focused_opacity:0.9,unfocused_opacity:0.9"
          "appid:slurp,noblur:1"
          "appid:foot,focused_opacity:0.9,unfocused_opacity:0.9"

        ];

        ## Outputs
        monitorrule = map (
          monitor:
          let
            splitPos = lib.splitString "x" monitor.position;
            x = builtins.elemAt splitPos 0;
            y = builtins.elemAt splitPos 1;
            disable = if monitor.enabled then "0" else "1";
          in
          "name:^${monitor.name}$,width:${toString monitor.width},height:${toString monitor.height},refresh:${toString monitor.refreshRate},x:${x},y:${y},scale:${toString monitor.scale},disable:${disable}"
        ) osConfig.monitors.all;

      };
    };
  };
}
