{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.waybar;

in
{
  options = {
    modules.waybar.enable = lib.mkEnableOption "waybar";
  };

  config = lib.mkIf cfg.enable {

    programs.waybar.enable = true;
    programs.waybar.systemd.enable = true;
    # home.file.".config/waybar/mediaplayer.py" = {
    #     source = ./mediaplayer.py;
    #     executable = true;
    # };

    programs.waybar.settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 5;
        fixed-center = true;

        modules-left = [
          "custom/wlogout"
          "clock"
          "hyprland/workspaces"
          "tray"
        ];
        modules-center = [
          "hyprland/window"
          "custom/spotify"
        ];
        modules-right = [
          "network"
          "backlight"
          "wireplumber"
          "battery"
        ];

        "wireplumber" = {
          format = "<span color='#202020' bgcolor='#83a598'>  </span> {volume}%";
          format-muted = "<span color='#202020' bgcolor='#ea6962'>  </span> {volume}%";
          tooltip-format = "{node_name}: {volume}%";

          scroll-step = 5.0;
          max-volume = 100;
        };

        "backlight" = {
          format = "<span color='#202020' bgcolor='#f6c657' >  </span> {percent}%";
          tooltip = false;

        };

        "tray" = {
          # icon-size = 15;
          spacing = 8;
        };

        "clock" = {
          format = "<span color='#202020' bgcolor='#8ec07c' >  </span> {:%a %d | %H:%M}";

        };

        "custom/spotify" = {
          format = "{icon} {}";
          escape = true;
          return-type = "json";
          max-length = 40;
          interval = 30;
          on-click = "playerctl -p spotify play-pause";
          on-click-right = "killall spotify";
          smooth-scrolling-threshold = 10;
          on-scroll-up = "playerctl -p spotify next";
          on-scroll-down = "playerctl -p spotify previous";
          exec = "~/.config/waybar/mediaplayer.py";
          exec-if = "pgrep spotify";

        };

        "hyprland/workspaces" = {
          show-special = true;
          on-click = "activate";
          active-only = false;
          all-outputs = true;
          special-visible-only = false;

          format = "{name} {windows} ";
          window-rewrite-default = "";
          window-rewrite = {
            "class<firefox>" = "󰈹";
            "class<obsidian>" = "󰎚";
            "class<spotify>" = "";
            "class<kitty>" = "";
            "class<vesktop>" = "";

            "code" = "󰨞";
          };

          persistent-workspaces = {
            "*" = 3;
          };
        };

        "hyprland/window" = {
          format = "{class}";
          seperate-outputs = true;
          icon = true;
          tooltip = false;
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "<span color='#202020' bgcolor='#50620F' > {icon} </span> {capacity}%";
          format-full = "<span color='#202020' bgcolor='#50620F' > {icon} </span> {capacity}%";
          format-charging = "<span color='#202020' bgcolor='#689d6a' > 󰂅{icon} </span> {capacity}%";
          format-critical = "<span color='#202020' bgcolor='#7a1405' > 󰂃 </span> {capacity}%!";
          format-warning = "<span color='#202020' bgcolor='#e78a4e' > {icon} </span> {capacity}%";

          format-icons = [
            "󰁹"
            "󰂀"
            "󰁾"
            "󰁼"
            "󰁺"
          ];
          format-off = "";

          tooltip-format = "{capacity}% Remaining... \nDraw: {power} Watt/s \nTime left: {time}";
          tooltip-format-charging = "{capacity} \nTill full: {time}";
          interval = 5;
        };

        "network" = {

          format = "<span color='#202020' bgcolor='#d3869b'>  </span> {ifname}";
          format-wifi = "<span color='#202020' bgcolor='#d3869b'> 󰖩 </span> {essid}";
          format-ethernet = "<span color='#202020' bgcolor='#d3869b'>  </span> {bandwidthUpBytes}  {bandwidthDownBytes}";
          format-disconnected = "<span color='#202020' bgcolor='#d3869b'> 󰖪 </span> Disconnected...";

          tooltip-format = " {ifname} via {gwaddr}";
          tooltip-format-wifi = "  {ifname} @ {essid}\nIP: {ipaddr}";
          tooltip-format-ethernet = " {ifname}\nIP: {ipaddr}\n up: {bandwidthUpBits} down: {bandwidthDownBits}";
          tooltip-format-disconnected = "AirPlane mode";
          interval = 5;

        };

        "custom/wlogout" = {
          format = "<span color='#202020' bgcolor='#158F9C'>  </span>";
          on-click = "wlogout";
          tooltip-format = "Toggle logout menu";
        };

      };
    };
  };
}
