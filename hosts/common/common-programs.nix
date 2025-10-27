{ pkgs, ... }:

{
  programs.zsh.enable = true;
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
    tumbler
  ];

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.ark
    pavucontrol
    wl-clipboard
    cliphist
    xdg-utils
    swtpm
    networkmanagerapplet
    libnotify
    brightnessctl
    nixfmt-tree
  ];
}
