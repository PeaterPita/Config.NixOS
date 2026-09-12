{ pkgs, ... }:
{

  home.packages = with pkgs; [
    obsidian
  ];

  modules = {
    mango.enable = true;
    discord.enable = true;
    feishin.enable = true;
    zathura.enable = true;
    mpv.enable = true;
    firefox.enable = true;
    syncthing.enable = true;
    office.enable = true;

    gaming = {
      enable = true;
      moonlight.enable = true;
    };

    zsh.enable = true;
    nixvim.enable = true;
    foot.enable = true;
    direnv.enable = true;
  };
}
