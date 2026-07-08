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
    environment.systemPackages = with pkgs; [

      ffmpeg
      kdePackages.dolphin

      kdePackages.ffmpegthumbs
    ];

  };
}
