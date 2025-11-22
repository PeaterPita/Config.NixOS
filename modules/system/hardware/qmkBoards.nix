{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.hardware.qmkBoards;
in
{
  options = {
    modules.hardware.qmkBoards.enable = lib.mkEnableOption "qmkBoards";
  };

  config = lib.mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;
    environment.systemPackages = with pkgs; [ via ];
    services.udev.packages = with pkgs; [ via ];
  };
}
