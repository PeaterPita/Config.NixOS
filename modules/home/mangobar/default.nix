{
  config,
  osConfig,
  lib,
  ...
}:

let
  cfg = config.modules.mangobar;
in
{
  options = {
    modules.mangobar.enable = lib.mkEnableOption "mangobar";
  };

  config = lib.mkIf cfg.enable {

    # TODO: Things to look into
    # Camera/Microphone Module
    # Image support, tray does something with pixmaps
    # Notification module
    # Calender Widget

    services.mangobar = {
      enable = true;
      settings = [
        {
          output = osConfig.monitors.primary.name;
          height = 34;
          modules-left = [
            "custom/nix"
            "workspaces"
          ];
          modules-center = [
            "custom/music"
          ];
          modules-right = [
            "tray"
            "network"
            "battery"
            "pulseaudio"
            "clock"
          ];

          workspaces = {
            hide-empty = true;
            pinned = [
              1
              2
              3
            ];
            on-click = "activate";
            scroll-interval = 100;
          };

          tray.icon-size = 14;

          pulseaudio = {
            on-scroll-up = "wpctl set-volume @DEFAULT_SINK@ 5%+";
            on-scroll-down = "wpctl set-volume @DEFAULT_SINK@ 5%-";
            scroll-interval = 100;
          };

          battery.format = "{icon} {percent}%";

          network = {
            format = " {ifname}";
            format-alt = "↓{down} ↑{up}";
          };

          "custom/nix" = {
            format = " 󱄅 ";
            interval = 0;
          };

          "custom/music" = {
            exec = "playerctl metadata --format '{{title}} - {{artist}}' || true";
            interval = 2;
            max-length = 360;
            on-click = "playerctl play-pause";
            on-scroll-up = "playerctl next";
            on-scroll-down = "playerctl previous";
          };
        }
      ];

    };

    # xdg.configFile."mangobar/style.css".source = ./style.css;

    # TODO: Remove
    xdg.configFile."mangobar/style.css".source =
      config.lib.file.mkOutOfStoreSymlink /home/peaterpita/nixos/modules/home/mangobar/style.css;
  };
}
