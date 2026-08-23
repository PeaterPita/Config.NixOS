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

    modules.dolphin.enable = true;
    programs.dconf.enable = true;
    services.udisks2.enable = true;

    security.soteria.enable = true;
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session";
        };
      };
    };

    environment = {
      systemPackages = with pkgs; [
        udiskie
        libnotify
        wl-clipboard
        cliphist
        networkmanagerapplet
      ];

      etc."xdg/menus/applications.menu".source =
        "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    };

    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          kdePackages.xdg-desktop-portal-kde
        ];
        config.common = {
          default = [
            "wlr"
            "gtk"
          ];

          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];

          "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
          "org.freedesktop.impl.portal.AppChooser" = [ "kde" ];
        };

        wlr = {
          enable = true;
          settings = {
            screencast = {
              chooser_type = "simple";
              chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
            };
          };
        };
      };
    };

  };
}
