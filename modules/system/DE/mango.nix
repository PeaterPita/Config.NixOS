{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.mango;
in
{
  options = {
    modules.mango.enable = lib.mkEnableOption "mango";
  };

  config = lib.mkIf cfg.enable {
    modules.wayland.enable = true;

    programs.mango = {
      enable = true;
      addLoginEntry = true;
    };

  };
}
