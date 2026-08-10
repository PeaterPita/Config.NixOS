{
  config,
  lib,
  ...
}:
let
  mangoEnabled = config.modules.mango.enable;
in
{
  config = lib.mkIf mangoEnabled {
    wayland.windowManager.mango.settings = {
      blur_optimized = 1;
    };
  };
}
