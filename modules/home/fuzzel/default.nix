{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.fuzzel;
in
{
  options = {
    modules.fuzzel.enable = lib.mkEnableOption "fuzzel";
  };
  config = lib.mkIf cfg.enable {

    modules.matugen.templates."fuzzel" = {
      outputPath = "~/.config/fuzzel/matugen.colors";
      text = ''
        [colors]
        background={{colors.background.default.hex_stripped}}ff
        text={{colors.on_surface.default.hex_stripped}}ff
        prompt={{colors.secondary.default.hex_stripped}}ff
        placeholder={{colors.tertiary.default.hex_stripped}}ff
        input={{colors.primary.default.hex_stripped}}ff
        match={{colors.tertiary.default.hex_stripped}}ff
        selection={{colors.background.default.hex_stripped}}ff
        selection-text={{colors.on_surface.default.hex_stripped}}ff
        selection-match={{colors.on_primary.default.hex_stripped}}ff
        counter={{colors.secondary.default.hex_stripped}}ff
        border={{colors.primary.default.hex_stripped}}ff
      '';
    };

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          include = "~/.config/fuzzel/matugen.colors";
          terminal = "${pkgs.foot}/bin/foot";
          layer = "overlay";
          icons-enabled = true;
        };
      };
    };

  };
}
