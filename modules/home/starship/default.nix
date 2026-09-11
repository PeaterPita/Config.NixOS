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

    modules.matugen.templates."starship" = {
      outputPath = "~/.config/starship.toml";
      text = ''
        format = "$directory$git_branch\n$character"

        palette = 'matugen'
        add_newline = true 
        right_format = "$nix_shell"

        [palettes.matugen]
        color1 = '{{colors.primary_fixed_dim.default.hex}}'
        color2 = '{{colors.on_primary.default.hex}}'
        color3 = '{{colors.on_surface_variant.default.hex}}'
        color4 = '{{colors.surface_container.default.hex}}'
        color5 = '{{colors.on_primary.default.hex}}'
        color6 = '{{colors.surface_dim.default.hex}}'
        color7 = '{{colors.surface.default.hex}}'
        color8 = '{{colors.primary.default.hex}}'
        color9 = '{{colors.tertiary.default.hex}}'

        [character]
        success_symbol = "[🞈](color9 bold)"
        error_symbol = "[🞈](@{error})"
        vicmd_symbol = "[🞈](#f9e2af)"

        [directory]
        format = "[](fg:color1 bg:color4)[󰉋](bg:color1 fg:color2)[ ](fg:color1 bg:color4)[$path ](fg:color3 bg:color4)[ ](fg:color4)"

        [directory.substitutions]
        "Documents" = "󰈙 "
        "Downloads" = " "
        "Music" = " "
        "Pictures" = " "

        [git_branch]
        format = "[](fg:color8 bg:color4)[ ](bg:color8 fg:color5)[](fg:color8 bg:color4)[(bg:color8 fg:color5) $branch](fg:color3 bg:color4)[](fg:color4) "

        [time]
        disabled = true

        [nix_shell]
        disabled = false 
        symbol = " "
        style = "bold blue"
        format = "[$symbol$state]($style)"
      '';
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
