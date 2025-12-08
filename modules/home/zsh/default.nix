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
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "arrow";
      };

    };
  };
}
