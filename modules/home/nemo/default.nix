{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.nemo;
in
{
  options = {
    modules.nemo.enable = lib.mkEnableOption "nemo";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nemo-with-extensions
    ];
  };
}
