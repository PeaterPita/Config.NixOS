{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.gaming.vintagestory;
in
{
  options = {
    modules.gaming.vintagestory.enable = lib.mkEnableOption "vintagestory";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ vintagestory ];
  };
}
