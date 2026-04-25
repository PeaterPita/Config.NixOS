{
  config,
  lib,
  pkgs,
  ...
}:

let
  vars = config.homelab;
  cfg = vars.services.it-tools;
in

{
  options.homelab.services.it-tools = {
    enable = lib.mkEnableOption "Enable IT-Tools";
    port = lib.mkOption { default = 3006; };
    domain = lib.mkOption { default = "tools.${vars.baseDomain}"; };
  };

  config = lib.mkIf cfg.enable {

    homelab.services.static-sites.packageSites.it-tools = {
      package = pkgs.it-tools;
      subfolder = "lib";
      port = cfg.port;
    };

    homelab.services.homepage.groups."Tools" = [
      {
        "IT-Tools" = {
          icon = "it-tools.png";
          href = "https://${cfg.domain}";
          description = "Dev Utils";
          ping = "http://127.0.0.1:${builtins.toString cfg.port}";
        };
      }
    ];

    homelab.services.authelia.rules = [
      {
        domain = [ cfg.domain ];
        policy = "one_factor";
        subject = [
          "group:family"
          "group:admin"
        ];
      }
    ];
  };
}
