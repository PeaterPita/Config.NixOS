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

    environment.systemPackages = with pkgs; [
      udiskie

      libnotify
      brightnessctl
      wl-clipboard

    ];
    services.udisks2.enable = true;
    programs = {
      hyprland.enable = true;
      hyprland.xwayland.enable = true;
      hyprlock.enable = true;
    };
    xdg.portal.enable = true;
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember";
          user = "peaterpita";
        };
      };
    };
  };

}
