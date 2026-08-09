{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.wayland;
in
{
  options = {
    modules.wayland.enable = lib.mkEnableOption "wayland";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      udiskie
      libnotify
      wl-clipboard
      networkmanagerapplet
    ];

    programs.dconf.enable = true;
    services.udisks2.enable = true;
    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          kdePackages.xdg-desktop-portal-kde
        ];
        config.common = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.AppChooser" = [ "kde" ];
        };
      };
    };

    environment.etc."xdg/menus/applications.menu".source =
      "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

    security.soteria.enable = true;
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session";
        };
      };
    };
  };

}
