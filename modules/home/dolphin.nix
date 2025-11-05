{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.dolphin;
in
{
  options = {
    modules.dolphin.enable = lib.mkEnableOption "dolphin";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kdePackages.dolphin

    ];

  };
}
