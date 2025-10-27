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

    services.network-manager-applet.enable = true;

    home.packages = with pkgs; [
      qimgv
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
        exec-once = "";

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

        # Block of window rules to allow KDE Presentation mode to "work" Still not perfect

        windowrule = [
          "nofocus, title:KDE Connect Daemon"
          "suppressevent fullscreen, title:KDE Connect Daemon"
          "float, title:KDE Connect Daemon"
          "opacity 1, title:KDE Connect Daemon"
          "noblur, title:KDE Connect Daemon"
          "noborder, title:KDE Connect Daemon"
          "noshadow, title:KDE Connect Daemon"
          "noanim, title:KDE Connect Daemon"
          "pin, title:KDE Connect Daemon"
          "minsize 1920 1080, title:KDE Connect Daemon"
          "move 0 0, title:KDE Connect Daemon"
        ];

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
          "$mod, E, exec, thunar"

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
