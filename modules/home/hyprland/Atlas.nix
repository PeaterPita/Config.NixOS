{
  config,
  lib,
  ...
}:
let
  hyprEnabled = config.modules.hyprland.enable;
in
{
  config = lib.mkIf hyprEnabled {
    wayland.windowManager.hyprland.settings = {
      input = {
        sensitivity = 0.3;
      };

      exec-once = [
        "feishin"
        "discord"
      ];

    };
  };
}
