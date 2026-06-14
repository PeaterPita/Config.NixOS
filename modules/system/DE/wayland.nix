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
    ];
    services.udisks2.enable = true;
    xdg.portal.enable = true;
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
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
