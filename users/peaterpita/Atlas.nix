{
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [
    parsec-bin
    typescript
  ];

  modules = {
    noctalia.enable = true;
    mango.enable = true;

    zsh.enable = true;
    nixvim.enable = true;
    kitty.enable = true;
    direnv.enable = true;
    spotify.enable = true;
    syncthing.enable = true;
    discord.enable = true;
    zathura.enable = true;
    mpv.enable = true;
    firefox.enable = true;
    zen.enable = true;
    obsidian.enable = true;
    office.enable = true;
    scrcpy.enable = true;

    gaming = {
      enable = true;
      prism.enable = true;
    };

    misc = {
      videoediting.enable = true;
      art.enable = true;
      research.enable = true;
    };
  };
}
