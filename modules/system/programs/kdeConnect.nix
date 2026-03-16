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
    programs.kdeconnect = {
      enable = true;
      package = lib.mkForce pkgs.unstable.kdePackages.kdeconnect-kde;
    };
  };
}
