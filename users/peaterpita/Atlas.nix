{
  pkgs,
  ...
}:

{

  home.packages = with pkgs.unstable; [
    element-desktop
    asunder
    vlc
    feishin
    picard
    libdvdcss
  ];

  modules = {

    spotify.enable = true;
    syncthing.enable = true;
    discord.enable = true;
    zathura.enable = true;
    mpv.enable = true;
    firefox.enable = true;
    obsidian.enable = true;
    office.enable = true;
    kdeConnect.enable = true;
    scrcpy.enable = true;
    quickshell.enable = true;

    gaming = {
      enable = true;
      prism.enable = true;
    };
  };
}
