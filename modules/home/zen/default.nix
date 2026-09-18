{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.zen;
in
{
  options = {
    modules.zen.enable = lib.mkEnableOption "zen";
  };

  config = lib.mkIf cfg.enable {

    xdg.mimeApps.defaultApplications = {
      "text/html" = "zen-beta.desktop";
      "x-schema-handler/http" = "zen-beta.desktop";
      "x-schema-handler/https" = "zen-beta.desktop";
    };

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
    };
  };
}
