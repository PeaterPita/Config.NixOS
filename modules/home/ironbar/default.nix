{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.ironbar;
in
{
  options = {
    modules.ironbar.enable = lib.mkEnableOption "ironbar";
  };

  config = lib.mkIf cfg.enable {

    home.packages = [
      pkgs.ironbar
      pkgs.dex
      pkgs.nerd-fonts.overpass
    ];

    xdg.configFile."ironbar/config.json".text = builtins.toJSON {

      monitors = {
        "${osConfig.monitors.primary.name}" = {

          position = "bottom";
          popup_gap = 0;
          start = [
            {
              type = "custom";
              bar = [
                {
                  type = "image";
                  src = ../../../assets/logos/NixOS-Standard.svg;
                  size = 36;
                }
              ];
            }

            { type = "workspaces"; }
          ];
          center = [

            { type = "clipboard"; }
            {
              type = "music";
              format = " {title} - {artist} ";
              marquee = {
                enable = true;
                max_length = 25;
                on_hover = "play";

              };

            }
            { type = "notifications"; }
          ];
          end = [
            { type = "tray"; }
            {
              type = "network_manager";

              types_blacklist = [
                "loopback"
                "veth"
                "ip_tunnel"
                "wireguard"
              ];

              interface_blacklist = [
                "docker0"
                "tailscale0"
              ];
            }
            { type = "volume"; }
            {
              type = "clock";
              format = "%H:%M";
            }
          ];

        };
      };
    };

  };
}
