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
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
      };
    };
  };
}
