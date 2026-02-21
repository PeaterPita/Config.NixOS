{
  pkgs,
  lib,
  config,
  ...
}:
let

  cfg = config.system.isDesktop;
in
{
  options.system.isDesktop = lib.mkEnableOption "Desktop mode";

  config = lib.mkMerge [
    {

      environment.defaultPackages = [ ]; # Remove all preinstalled packages

      programs.zsh.enable = true;
      services.openssh.enable = true;
      virtualisation.docker.enable = true;

    }

    (lib.mkIf cfg {

      modules = {
        tailscale.enable = true;
        networking.enable = true;
        sound.enable = true;
        yazi.enable = true;
      };

      services.mullvad-vpn.enable = true;

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

      environment.systemPackages = with pkgs; [
        kdePackages.ark
        unrar
        feh
        ncdu
        xdg-utils
        nixfmt-tree
      ];
    })
  ];
}
