{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.hardware.camera;
in
{
  options = {
    modules.hardware.camera.enable = lib.mkEnableOption "cameractrls";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ cameractrls-gtk4 ];
  };
}
