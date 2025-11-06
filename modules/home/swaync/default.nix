{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.swaync;
in
{
  options = {
    modules.swaync.enable = lib.mkEnableOption "swaync";
  };

  config = lib.mkIf cfg.enable {
    services.swaync = {
      enable = true;
      settings = {
        positionX = "center";
        control-center-positionX = "right";
        notification-2fa-action = true;
        notification-grouping = true;
        widgets = [
          "title"
          "mpris"
          "notifications"
          "inhibitors"
        ];
        widget-config = {
          mpris = {
            show-album-art = true;
            loop-carousel = true;
            autohide = true;
          };

          buttons-grid = {
            buttons-per-row = 3;
            actions = [
              {
                label = "1";
              }
            ];
          };

        };
        style = ''

          root {
              --mpris-album-art-icon-size: 64;

          }


        '';
      };
    };
  };
}
