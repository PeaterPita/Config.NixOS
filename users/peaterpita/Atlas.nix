{
  lib,
  ...
}:

{
  modules = {
    discord.enable = true;
    syncthing.enable = true;
    kdeConnect.enable = true;
    scrcpy.enable = true;

    # packetTrace.enable = true;
    office.enable = true;
    gaming = {
      vintagestory.enable = true;
      prism.enable = true;
    };
  };
}
