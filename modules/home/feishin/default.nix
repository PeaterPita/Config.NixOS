{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.feishin;
in
{
  options = {
    modules.feishin.enable = lib.mkEnableOption "feishin";
  };

  config = lib.mkIf cfg.enable {
    modules.matugen.templates."feishin" = {
      outputPath = "~/.config/feishin/Themes/matugen.json";
      text = ''
        {
          "mode": "dark",
          "colors": {
            "background": "{{colors.background.default.hex}}",
            "background-alternate": "{{colors.surface_container.default.hex}}",
            "surface": "{{colors.surface_container_high.default.hex}}",
            "surface-foreground": "{{colors.on_surface.default.hex}}",
            "foreground": "{{colors.on_surface.default.hex}}",
            "foreground-muted": "{{colors.outline.default.hex}}",
            "primary": "{{colors.primary.default.hex}}"
          }
        }
      '';
    };
    home.packages = with pkgs; [ feishin ];
  };
}
