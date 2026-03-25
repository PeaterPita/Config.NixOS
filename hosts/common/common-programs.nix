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
        fonts.enable = true;
      };

      services.mullvad-vpn.enable = true;
      services.mullvad-vpn.package = pkgs.mullvad-vpn;

      services.xserver.enable = true;

      environment.systemPackages = with pkgs; [
        kdePackages.ark
        unrar
        swww
        feh
        ncdu
        xdg-utils
        nixfmt-tree
      ];
    })
  ];
}
