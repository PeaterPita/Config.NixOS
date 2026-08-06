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
    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
    };
  };
}
