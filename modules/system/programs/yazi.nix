{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.yazi;
in
{
  options = {
    modules.yazi.enable = lib.mkEnableOption "yazi";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      settings.yazi = { };

    };

  };
}
