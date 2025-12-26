{
  lib,
  pkgs,
  ...
}:

{

  home.packages = with pkgs; [ gnome-disk-utility ];

  modules = {
    spotify.enable = true;
    kdeConnect.enable = true;
    scrcpy.enable = true;

    gaming = {
      enable = true;
      vintagestory.enable = true;
      prism.enable = true;
    };
  };
}
