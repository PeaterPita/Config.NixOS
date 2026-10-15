{
  config,
  lib,
  pkgs,
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

      ffmpeg
      kdePackages.dolphin

      kdePackages.ffmpegthumbs

    ];

    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
    };

  };
}
