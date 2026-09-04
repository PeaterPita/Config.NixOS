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
    modules.starship.enable = true;
    home.packages = [ pkgs.monocraft ];

    services.mako = {
      enable = true;
      settings = {
      };
    };
  };
}
