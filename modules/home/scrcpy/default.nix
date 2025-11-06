{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.scrcpy;
in
{
  options = {
    modules.scrcpy.enable = lib.mkEnableOption "scrcpy";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      android-tools
      scrcpy
    ];
  };
}
