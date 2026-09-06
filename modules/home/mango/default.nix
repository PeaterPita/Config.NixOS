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
    };

    services.awww.enable = true;
    home.packages = with pkgs; [
      waypaper
      matugen
    ];

    wayland.windowManager.mango = {
      enable = true;
      settings = {
        source-optional = "./noctalia.conf";

        exec-once = [
          "udiskie"
          "noctalia"
          "anyrun daemon"
          "mangobar"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
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

        ## Animations
        animations = 1;

        tag_animation_direction = 0;
        animation_type = {
          open = "zoom";
          close = "fade";
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

            "SUPER+SHIFT,S,spawn,noctalia msg screenshot-region"
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
