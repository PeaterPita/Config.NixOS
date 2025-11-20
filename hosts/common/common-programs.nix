{
  pkgs,
  lib,
  config,
  ...
}:

{
  programs.zsh.enable = true;
  services.openssh.enable = true;

  modules = {
    tailscale.enable = true;
    networking.enable = true;
    sound.enable = true;
    docker.enable = true;
  };

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
    services.postgresql = {
        enable = true;
        ensureDatabases = [ "postgres" ];
        authentication = pkgs.lib.mkOverride 10 ''
            #type database DBuser auth-method
            local all all trust
            host all all 127.0.0.1/32 trust
            host all all ::1/128 trust
        '';

    };

  environment.defaultPackages = [ ]; # Remove all preinstalled packages
  environment.systemPackages = with pkgs; [
    kdePackages.ark
    pinta
    wl-clipboard
    zathura
    xdg-utils
    libnotify
    brightnessctl
    nixfmt-tree
  ];
}
