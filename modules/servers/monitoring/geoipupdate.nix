{ config, lib, ... }:

let
  cfg = config.homelab.services.monitoring.geoipupdate;
in

{
  options.homelab.services.monitoring.geoipupdate = {
    enable = lib.mkEnableOption "MaxMind GeoIPUpdate database";
  };

  config = lib.mkIf cfg.enable {

    sops.secrets."geoip/license_key" = {
      sopsFile = ../../../secrets/services.yaml;
    };

    services.geoipupdate = {
      enable = true;
      settings = {
        AccountID = 1360454;
        LicenseKey = {
          _secret = config.sops.secrets."geoip/license_key".path;
        };
        EditionIDs = [
          "GeoLite2-City"
          "GeoLite2-ASN"
        ];

      };
    };

  };

}
