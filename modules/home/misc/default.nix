{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.misc;
in
{
  options = {
    modules.misc.enable = lib.mkEnableOption "misc";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      picard
      asunder
      libdvdcss
    ];

  };
}
