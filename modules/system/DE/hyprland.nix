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

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };
}
