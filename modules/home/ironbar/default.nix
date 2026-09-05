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

    home.packages = [ pkgs.ironbar ];

    xdg.configFile."ironbar/config.json".text = builtins.toJSON {

      monitors = {
        "${osConfig.monitors.primary.name}" = {

          position = "bottom";
          start = [
            { type = "menu"; }
            { type = "workspaces"; }
          ];
          center = [

            { type = "clipboard"; }
            { type = "music"; }
            { type = "notifications"; }
          ];
          end = [
            { type = "tray"; }
            { type = "network_manager"; }
            { type = "volume"; }
            { type = "clock"; }
          ];

        };
      };
    };

  };
}
