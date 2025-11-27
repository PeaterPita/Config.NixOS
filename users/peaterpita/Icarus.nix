{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

{

  # stylix.image = pkgs.fetchurl {
  #   url = "https://w.wallhaven.cc/full/6l/wallhaven-6lqvql.jpg";
  #   hash = "sha256-1HpDc/nqDpWYK0HC+KajvvaADTky80bRqorcNeXtp5k=";
  # };
  #
  # stylix.polarity = "dark";
  # stylix.opacity = {
  #   applications = 1.0;
  #   terminal = 0.8;
  #   desktop = 1.0;
  #   popups = 0.8;
  # };
  # stylix.fonts = rec {
  #   monospace = {
  #     package = pkgs.nerd-fonts.fira-code;
  #     name = "FiraCode Nerd Font Mono";
  #   };
  #   sansSerif = monospace;
  #   serif = monospace;
  #   emoji = {
  #     package = pkgs.noto-fonts-emoji;
  #     name = "Noto Color Emoji";
  #   };
  #   sizes = {
  #     terminal = 12;
  #     desktop = 12;
  #     popups = 10;
  #   };
  #
  # };

  home.packages = with pkgs; [ putty ];
  modules = {
    # hyprland.enable = true;
    syncthing.enable = true;
    kdeConnect.enable = true;
    obsidian.enable = true;
    office.enable = true;
    packetTrace.enable = true;
    gaming.prism.enable = true;
  };
}
