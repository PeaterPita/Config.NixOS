{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.gaming.prism;
in
{
  options = {
    modules.gaming.prism.enable = lib.mkEnableOption "prism";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      prismlauncher
    ];
  };
}
