{ config, lib, ... }:

{
  config = lib.mkIf config.modules.noctalia.enable {
    programs.noctalia.settings = {
      bar.default = {
        margin_edge = 0;
        margin_ends = 0;
        radius = 0;
        widget_spacing = 10;

        start = [
          "control-center"
          "taskbar"
        ];
        end = [
          "tray"
          "network"
          "bluetooth"
          "battery"
          "volume"
          "clock"
        ];
      };
    };

  };
}
