{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.theme;
in
{
  options.modules.theme.enable = lib.mkEnableOption "theme";

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name    = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name    = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name    = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size    = 24;
      };
    };

    home.pointerCursor = {
      name    = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size    = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style = {
        name    = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
  };
}
