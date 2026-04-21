{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.static-sites;

  siteSubmodule = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "Package containing the static site files to serve";
      };

      port = lib.mkOption {
        type = lib.types.port;
        description = "Port for nginx to listen on";
      };
    };
  };
in

{
  options.homelab.services.static-sites = {
    sites = lib.mkOption {
      type = lib.types.attrsOf siteSubmodule;
      default = { };
      description = "Static sites to serve via nginx";
    };
  };

  config = lib.mkIf (cfg.sites != { }) {

    networking.firewall.allowedTCPPorts = lib.mapAttrsToList (_: site: site.port) cfg.sites;

    services.nginx = {
      enable = true;

      virtualHosts = builtins.mapAttrs (name: site: {
        listen = [
          {
            addr = "0.0.0.0";
            port = site.port;
          }
        ];

        root = site.package;

        locations."/" = {
          tryFiles = "$uri $uri/index.html $uri.html =404";
        };

        extraConfig = ''
          error_page 404 /404.html;
        '';
      }) cfg.sites;
    };
  };
}
