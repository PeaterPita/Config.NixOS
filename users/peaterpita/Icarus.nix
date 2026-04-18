{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    file
    feishin
  ];

  modules = {
    hyprland.enable = true;
    discord.enable = true;
    zathura.enable = true;
    mpv.enable = true;
    firefox.enable = true;
    syncthing.enable = true;
    obsidian.enable = true;
    office.enable = true;
    spotify.enable = true;
    quickshell.enable = true;

    zsh.enable = true;
    nixvim.enable = true;
    kitty.enable = true;
    zellij.enable = true;
    direnv.enable = true;
  };
}
