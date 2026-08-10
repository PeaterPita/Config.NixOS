{
  config,
  lib,
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
      kitty.enable = true;
    };

    wayland.windowManager.mango = {
      enable = true;
      settings = {
        source-optional = "./noctalia.conf";

        exec-once = [
          "udiskie"
          "noctalia"
        ];

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
          speed = 0.3;
        };

        bind = [
          # General
          "SUPER,Q,spawn,kitty"
          "SUPER,E,spawn,dolphin"
          "SUPER,W,killclient"
          "SUPER,R,reload_config"

          "SUPER,L,spawn,noctalia msg session lock"
          "SUPER,Space,spawn,noctalia msg panel-toggle launcher"
          "SUPER+SHIFT,S,spawn,noctalia msg screenshot-region"

          "SUPER+SHIFT,F,togglefloating"
          "SUPER,F,togglemaximizescreen"

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
          "ALT,F,toggle_named_scratchpad,none,scratch-term,kitty -T scratch-term"

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

              primary = builtins.head (builtins.filter (monitor: monitor.primary) osConfig.monitors);
              ws = i + 1;
              ipc = "mmsg dispatch";
            in
            [
              "SUPER,${toString ws},spawn_shell, ${ipc} focusmon,${primary.name} && ${ipc} view,${toString ws}"
              "SUPER+SHIFT,${toString ws},spawn_shell, ${ipc} focusmon,${primary.name} && ${ipc} tag,${toString ws}"
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
          "isnamedscratchpad:1,isfloating:1,title:scratch-term"
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
        ) osConfig.monitors;

      };
    };
  };
}
