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
    programs.fuzzel.enable = true;
    programs.fuzzel.settings = {
      main = {
        terminal = "kitty -1";
        prompt = ">> ";
        layer = "overlay";
      };

      dmenu = {
        exit-immediately-if-empty = "yes";
      };
    };
  };
}
