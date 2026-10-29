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
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "${pkgs.foot}/bin/foot";
          layer = "overlay";
          icons-enabled = true;
        };
        ## TODO: Matugen theme
        colors.background = "ffffffff";
      };
    };

  };
}
