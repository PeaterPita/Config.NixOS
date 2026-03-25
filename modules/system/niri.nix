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
  options.modules.niri.enable = lib.mkEnableOption "niri";

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;

    xdg.portal.enable = true;
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];

    environment.systemPackages = with pkgs; [
      udiskie
      swaylock
      libnotify
      brightnessctl
      wl-clipboard
    ];
    services.udisks2.enable = true;

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
