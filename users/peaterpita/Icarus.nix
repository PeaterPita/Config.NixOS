{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

{

  stylix.image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/0q/wallhaven-0qo2r4.jpg";
    hash = "sha256-+1uV0Qh4Y8oXAc6ZGjn4sVPhFZIgD86kMioe+niDEiM=";
  };

  stylix.polarity = "dark";
  stylix.opacity = {
    applications = 1.0;
    terminal = 0.8;
    desktop = 1.0;
    popups = 0.8;
  };
  stylix.fonts = rec {
    monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font Mono";
    };
    sansSerif = monospace;
    serif = monospace;
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
    sizes = {
      terminal = 12;
      desktop = 12;
      popups = 10;
    };

  };

  modules = {
    waybar.enable = lib.mkDefault true;
    hyprland.enable = true;
    syncthing.enable = true;
    obsidian.enable = true;
    office.enable = true;
    packetTrace.enable = true;
    swaync.enable = true;
  };
}
