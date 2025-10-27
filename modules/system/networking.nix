{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.networking;
in
{
  options = {
    modules.networking.enable = lib.mkEnableOption "networking";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;
    programs.nm-applet.enable = true;

  };
}
