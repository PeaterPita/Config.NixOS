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

    modules = {
      fuzzel.enable = true;
      waybar.enable = true;
      swaync.enable = true;
    };

    home.packages = with pkgs; [
      ffmpeg
      grimblast
    ];

    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "hyprlock";
          text = "Lock";
        }
        {
          label = "logout";
          action = "hyprctl dispatch exit";
          text = "logout";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "reboot";
        }

      ];
    };
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        exec-once = [
          "udiskie"
          "qs"
          "swww-daemon"
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
          "$mod, L, exec, hyprlock"
          "$mod SHIFT, F, togglefloating"

          "$mod SHIFT, W, exec, pkill waybar || waybar "
          "$mod, n, exec, swaync-client -t -sw"

          "$mod, Left, movefocus, l"
          "$mod, Right, movefocus, r"
          "$mod, Up, movefocus, u"
          "$mod, Down, movefocus, d"

          "$mod SHIFT, left,  resizeactive, -100 0"
          "$mod SHIFT, right, resizeactive, 100 0"
          "$mod SHIFT, up,    resizeactive, 0 -100"
          "$mod SHIFT, down,  resizeactive, 0 100"

          "$mod, Space, exec, fuzzel"
          "$mod, Q, exec, kitty"
          "$mod, E, exec, dolphin"

          "$mod SHIFT, S, exec, grimblast --notify --freeze copysave area"

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
