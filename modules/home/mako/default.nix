{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.mako;
in
{
  options = {
    modules.mako.enable = lib.mkEnableOption "mako";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.monocraft ];

    modules.matugen.templates."mako" = {
      outputPath = "~/.config/mako/matugen.colors";
      reloadCmd = "makoctl reload";

      text = ''
        background-color={{colors.on_primary.default.hex}}
        text-color={{colors.tertiary.default.hex}}
        border-color={{colors.tertiary_container.default.hex}}

        [mode=do-not-disturb]
        invisible=1
        on-notify=none

        [mode=silent]
        on-notify=none

        [urgency=high]
        border-color={{colors.error_container.default.hex}}
      '';
    };

    services.mako = {
      enable = true;
      settings = {

        actions = true;
        anchor = "top-right";
        default-timeout = 5000;
        font = "monocraft 10";
        icons = true;
        layer = "overlay";

        include = "~/.config/mako/matugen.colors";
      };
    };
  };
}
