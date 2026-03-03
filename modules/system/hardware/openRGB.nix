{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.hardware.openRGB;
in
{
  options = {
    modules.hardware.openRGB.enable = lib.mkEnableOption "openRGB";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = [ "mbedtls-2.28.10" ];
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.unstable.openrgb-with-all-plugins;
    };
  };
}
