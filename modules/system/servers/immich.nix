{
  config,
  lib,
  pkgs,
  ...
}:

let
  vars = config.homelab;
  cfg = vars.services.immich;
  mediaLoc = "/mnt/immich/";
in

{
  options.homelab.services.immich = {
    enable = lib.mkEnableOption "Enable Immich, replacing google photos";
    port = lib.mkOption { default = 2283; };
    domain = lib.mkOption { default = "photos.${vars.baseDomain}"; };
  };

  config = lib.mkIf cfg.enable {

    homelab.services.homepage.disks = [ "/mnt/immich/" ];

    systemd.tmpfiles.rules = [
      "d ${mediaLoc} 0775 root immich - -"
    ];

    homelab.services.homepage.groups."Apps" = [
      {
        Immich = {
          icon = "immich.png";
          href = "http://${cfg.domain}";
          description = "Photo Storage & Backup";
          ping = "https://${cfg.domain}";
        };
      }
    ];

    services.immich = {
      enable = true;
      port = cfg.port;
      host = "0.0.0.0";
      openFirewall = true;
      database = {
        enable = true;
        createDB = true;
      };
      mediaLocation = mediaLoc;
    };

  };
}
