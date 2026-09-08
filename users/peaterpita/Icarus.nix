{ pkgs, ... }:
{

  home.packages = with pkgs; [ feishin ];

  modules = {
    hyprland.enable = true;
    discord.enable = true;
    zathura.enable = true;
    mpv.enable = true;
    firefox.enable = true;
    syncthing.enable = true;
    obsidian.enable = true;
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
