{
  lib,
  pkgs,
  ...
}:

{

  modules = {
    spotify.enable = true;
    kdeConnect.enable = true;
    scrcpy.enable = true;

    gaming = {
      vintagestory.enable = true;
      prism.enable = true;
    };
  };
}
