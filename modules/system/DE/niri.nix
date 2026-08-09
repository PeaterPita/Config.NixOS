{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.niri;
in
{
  options = {
    modules.niri.enable = lib.mkEnableOption "niri";
  };

  config = lib.mkIf cfg.enable {
    modules.wayland.enable = true;
    modules.dolphin.enable = true;

    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [ xwayland-satellite ];

  };
}
