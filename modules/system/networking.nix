{
  config,
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

    networking.wireless.networks.eduroam = {
      auth = ''
        key_mgmt=WPA-EAP
        eap=PEAP

        identity = "[ID]@[UNI].ac.uk"
        password = ""
      '';

    };

  };
}
