{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.kdeConnect;
in
{
  options = {
    modules.kdeConnect.enable = lib.mkEnableOption "kdeConnect";
  };

  config = lib.mkIf cfg.enable {
    services.kdeconnect.enable = true;
  };
}
