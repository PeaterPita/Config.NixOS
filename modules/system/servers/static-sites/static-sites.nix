{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.static-sites;

  packageSiteModule = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
      };
      subfolder = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      port = lib.mkOption {
        type = lib.types.port;
      };
    };
  };

  allPorts = (lib.mapAttrsToList (_: s: s.port) cfg.packageSites);
  mkNginxHost = _: site: {
    listen = [
      {
        addr = "0.0.0.0";
        port = site.port;
      }
    ];
    root = if site.subfolder == "" then site.package else "${site.package}/${site.subfolder}";
    locations."/".tryFiles = "$uri $uri/index.html $uri.html =404";
    extraConfig = "error_page 404 /404.html;";
  };

in
{
  options.homelab.services.static-sites = {
    packageSites = lib.mkOption {
      type = lib.types.attrsOf packageSiteModule;
      default = { };
    };

  };

  config = lib.mkIf (cfg.packageSites != { }) {
    networking.firewall.allowedTCPPorts = allPorts;

    services.nginx = {
      enable = true;
      virtualHosts = lib.mkMerge [
        (builtins.mapAttrs mkNginxHost cfg.packageSites)
      ];
    };

  };
}
