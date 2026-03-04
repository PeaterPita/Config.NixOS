{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.networking;
in
{
  options.modules.networking = {
    enable = lib.mkEnableOption "networking";
    wireless.enable = lib.mkEnableOption "wireless support";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [

      {
        networking.networkmanager.enable = true;
        systemd.services.NetworkManager-wait-online.enable = false;
      }

      (lib.mkIf cfg.wireless.enable {

        sops.secrets."networks/eduroam" = { };
        programs.nm-applet.enable = true;

        networking.networkmanager.ensureProfiles = {
          environmentFiles = [ config.sops.secrets."networks/eduroam".path ];
          profiles = {
            eduroam = {
              connection = {
                id = "eduroam";
                type = "wifi";
              };
              wifi = {
                ssid = "eduroam";
                mode = "infrastructure";
              };
              wifi-security = {
                key-mgmt = "wpa-eap";
              };
              "802-1x" = {
                eap = "peap";
                identity = "$EDUROAM_USERNAME";
                password = "$EDUROAM_PASSWORD";
                phase2-auth = "mschapv2";
              };
              ipv4.method = "auto";
            };
          };

        };
      })
    ]
  );
}
