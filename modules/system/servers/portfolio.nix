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

    homelab.services.homepage.bookmarks."Personal" = [
      {
        Portfolio = [
          {
            abbr = "PO";
            href = "https://${vars.baseDomain}";
            icon = "mdi-web-#4B006e";
          }
        ];
      }
    ];
  };
}
