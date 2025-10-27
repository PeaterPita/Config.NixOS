{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.prism;
in
{
  options = {
    modules.prism.enable = lib.mkEnableOption "prism";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ prismlauncher ];

  };
}
