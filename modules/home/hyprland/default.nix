{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  cfg = config.modules.hyprland;
in
{
  options = {
    modules.hyprland.enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    modules.nemo.enable = true;
    services.network-manager-applet.enable = true;

    modules.noctalia.enable = true;
    home.packages = with pkgs; [
      ffmpeg
      grimblast
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "hyprlang";
      settings = {
        "$mod" = "SUPER";
        exec-once = [
          "udiskie"
          "qs"
          "awww-daemon"
          "noctalia"
        ];

        general = {
          gaps_out = 0;
          gaps_in = 0;
        };

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
