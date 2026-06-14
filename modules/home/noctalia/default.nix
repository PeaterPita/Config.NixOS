{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.noctalia;
in
{
  options = {
    modules.noctalia.enable = lib.mkEnableOption "noctalia";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    home.packages = with pkgs; [
      monocraft
    ];

    programs.noctalia = {
      enable = true;
      settings = {

        bar = {

          default = {
            margin_edge = 0;
            margin_ends = 0;
            radius = 0;
            widget_spacing = 10;

            start = [
              "control-center"
              "clock"
              "workspaces"
            ];
            center = [
              "media"
              "notifications"
            ];
            end = [
              "tray"
              "network"
              "bluetooth"
              "volume"
              "battery"
            ];

          };

        };

        shell = {
          font_family = "monocraft";
          panel = {
            transparency_mode = "glass";
            launcher_placement = "attached";
          };
        };

      };
    };
  };
}
