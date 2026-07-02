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
      modules.networking.enable = true;

      programs.nano.enable = false;

      environment.systemPackages = with pkgs; [ kitty.terminfo ];
    }

    (lib.mkIf cfg {
      users.defaultUserShell = pkgs.zsh;

      modules = {
        tailscale.enable = true;
        sound.enable = true;
        fonts.enable = true;
      };

      programs.zsh.enable = true;

      services = {

        mullvad-vpn = {
          enable = true;
          package = pkgs.mullvad-vpn;
        };

        xserver = {
          enable = true;
          excludePackages = [ pkgs.xterm ];
        };
      };

      qt = {
        enable = true;
        platformTheme = "kde";
        style = "breeze";
      };

      environment.systemPackages = with pkgs; [
        kdePackages.ark
        vim
        unrar
        brightnessctl
        qimgv
        ncdu
        xdg-utils
      ];
    })
  ];
}
