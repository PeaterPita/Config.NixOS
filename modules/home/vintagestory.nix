{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.vintagestory;
in
{
  options = {
    modules.vintagestory.enable = lib.mkEnableOption "vintagestory";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ vintagestory ];
  };
}
