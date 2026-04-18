{
  pkgs,
  ...
}:

{

  home.packages = with pkgs.unstable; [
    vlc
    feishin
    claude-code
  ];

  modules = {

    zsh.enable = true;
    nixvim.enable = true;
    kitty.enable = true;
    zellij.enable = true;
    direnv.enable = true;
    spotify.enable = true;
    syncthing.enable = true;
    discord.enable = true;
    zathura.enable = true;
    mpv.enable = true;
    firefox.enable = true;
    obsidian.enable = true;
    office.enable = true;
    scrcpy.enable = true;
    quickshell.enable = true;

    gaming = {
      enable = true;
      prism.enable = true;
    };
  };
}
