{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.mango;
in
{
  options = {
    modules.mango.enable = lib.mkEnableOption "mango";
  };

  config = lib.mkIf cfg.enable {
    modules.wayland.enable = true;
    modules.dolphin.enable = true;

    programs.mango = {
      enable = true;
      addLoginEntry = true;
    };

    xdg.portal.wlr = {
      enable = true;
      settings = {
        screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
        };
      };
    };
  };
}
