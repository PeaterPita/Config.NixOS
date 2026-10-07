{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.zathura;

in
{
  options = {
    modules.zathura.enable = lib.mkEnableOption "zathura";
  };

  config = lib.mkIf cfg.enable {

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "zathura.desktop";
    };

    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
      };
    };
  };
}
