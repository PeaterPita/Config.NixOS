{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.hardware.openRGB;
in
{
  options = {
    modules.hardware.openRGB.enable = lib.mkEnableOption "openRGB";
  };

  config = lib.mkIf cfg.enable {
    services.hardware.openrgb.enable = true;

  };
}
