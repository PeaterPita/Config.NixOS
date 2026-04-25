{
  config,
  lib,
  inputs,
  ...
}:

let
  vars = config.homelab;
  cfg = vars.services.portfolio;
in

{
  options.homelab.services.portfolio = {
    enable = lib.mkEnableOption "Enable the portfolio site";
    port = lib.mkOption { default = 3005; };
    domain = lib.mkOption { default = vars.baseDomain; };
  };

  config = lib.mkIf cfg.enable {

    homelab.services.static-sites.packageSites.portfolio = {
      package = inputs.astro-site.packages.x86_64-linux.default;
      port = cfg.port;
    };

    homelab.services.homepage.groups."Personal" = [
      {
        Portfolio = {
          icon = "globe";
          href = "https://${cfg.domain}";
          description = "Personal Portfolio";
          ping = "http://127.0.0.1:${builtins.toString cfg.port}";
        };
      }
    ];
  };
}
