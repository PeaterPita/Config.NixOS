{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.zsh;
in
{
  options = {
    modules.zsh.enable = lib.mkEnableOption "zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
