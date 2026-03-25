{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.fonts;
in
{
  options.modules.fonts.enable = lib.mkEnableOption "fonts";

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      noto-fonts-color-emoji
    ];
    fonts.fontconfig.defaultFonts = {
      monospace = [ "FiraCode Nerd Font Mono" ];
      sansSerif = [ "FiraCode Nerd Font" ];
      serif    = [ "FiraCode Nerd Font" ];
      emoji    = [ "Noto Color Emoji" ];
    };
  };
}
