{
  pkgs,
  lib,
  config,
  ...
}:

{
  programs.zsh.enable = true;
  services.openssh.enable = true;
  services.mullvad-vpn.enable = true;

  modules = {
    tailscale.enable = true;
    networking.enable = true;
    sound.enable = true;
    yazi.enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "ciscoPacketTracer8-8.2.2"
    # "qtwebengine-5.15.19"
  ];
  services.xserver.enable = true;
  # Default background image + color scheme
  stylix = lib.mkIf (!config.modules.plasma.enable) {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nix-wallpaper-nineish-catppuccin-macchiato-alt.png?raw=true";
      hash = "sha256-OUT0SsToRH5Zdd+jOwhr9iVBoVNUKhUkJNBYFDKZGOU=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/brewer.yaml";

  };
  virtualisation.docker.enable = true;

  environment.defaultPackages = [ ]; # Remove all preinstalled packages
  environment.systemPackages = with pkgs; [
    kdePackages.ark
    unrar
    feh
    ncdu
    xdg-utils
    nixfmt-tree

  ];
}
