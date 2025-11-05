{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.hardware.g502;
in
{
  options = {
    modules.hardware.g502.enable = lib.mkEnableOption "g502";
  };

  config = lib.mkIf cfg.enable {
    services.ratbagd.enable = true;
    environment.systemPackages = with pkgs; [ piper ];
  };
}
