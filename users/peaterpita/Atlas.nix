{
  lib,
  pkgs,
  ...
}:

{

  home.packages = with pkgs.unstable; [
    blockbench

    teamspeak6-client
  ];

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
