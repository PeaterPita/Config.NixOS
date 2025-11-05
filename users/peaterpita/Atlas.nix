{
  lib,
  pkgs,
  ...
}:

{
  modules = {
    syncthing.enable = true;
    kdeConnect.enable = true;
    scrcpy.enable = true;

    # packetTrace.enable = true;
    gaming = {
      vintagestory.enable = true;
      prism.enable = true;
    };
  };
}
