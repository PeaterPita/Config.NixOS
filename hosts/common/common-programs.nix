{
  pkgs,
  lib,
  config,
  ...
}:

{
  programs.zsh.enable = true;

  services.openssh.enable = true;
  modules.tailscale.enable = true;
  modules.networking.enable = true;
  modules.sound.enable = true;

  services.xserver.enable = true;
  services.journald.extraConfig = "SystemMaxUse=100M";
  # Default background image + color scheme
  stylix = lib.mkIf (!config.modules.plasma.enable) {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nix-wallpaper-nineish-catppuccin-macchiato-alt.png?raw=true";
      hash = "sha256-OUT0SsToRH5Zdd+jOwhr9iVBoVNUKhUkJNBYFDKZGOU=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/brewer.yaml";

  };
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  environment.defaultPackages = [ ]; # Remove all preinstalled packages
  environment.systemPackages = with pkgs; [
    kdePackages.ark
    wl-clipboard
    cliphist
    xdg-utils
    swtpm
    libnotify
    brightnessctl
    nixfmt-tree
  ];
}
