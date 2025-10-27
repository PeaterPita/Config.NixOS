{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.tmux;
in
{
  options = {
    modules.tmux.enable = lib.mkEnableOption "tmux";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {

      plugins = with pkgs.tmuxPlugins; [
        sensible
        resurrect
        continuum
        yank
      ];
      enable = true;
      clock24 = true;
      baseIndex = 1;
      prefix = "C-a";

      mouse = true;
      keyMode = "vi";
      extraConfig = ''
        set -g status-bg colour235
        set -g status-fg white
        set -g pane-border-style fg=colour237
        set -g pane-active-border-style fg=colour4
        set -g status-left-length 30
        set -g status-right length 120

        bind-key c new-window -c "#{pane_current_path}"
        bind-key q killp


      '';

    };
  };
}
