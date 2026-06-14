{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.starship;
in
{
  options = {
    modules.starship.enable = lib.mkEnableOption "starship";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      presets = [ "pastel-powerline" ];
      settings = {
        add_newline = true;

        right_format = "$nix_shell";

        time = {
          disabled = true;
        };

        nix_shell = {
          disabled = false;
          symbol = " ";
          style = "bold blue";
          format = "[$symbol$state]($style)";
        };

      };

    };
  };
}
