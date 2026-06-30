{
  pkgs,
  ...
}:

{

  home.packages = with pkgs.unstable; [
    claude-code
  ];

  modules = {

    noctalia.enable = true;
    hyprland.enable = true;

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
    obsidian.enable = true;
    office.enable = true;
    scrcpy.enable = true;

    gaming = {
      enable = true;
      prism.enable = true;
    };
  };
}
