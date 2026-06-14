{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.hyprland;
in
{
  options = {
    modules.hyprland.enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
    modules.wayland.enable = true;

    programs = {
      hyprland.enable = true;
      hyprland.xwayland.enable = true;
      hyprlock.enable = true;
    };
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };
}
