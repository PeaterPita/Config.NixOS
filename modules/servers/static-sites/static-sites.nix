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

  ciSitesModule = lib.types.submodule {
    options.port = lib.mkOption { type = lib.types.port; };
  };

  allPorts =
    (lib.mapAttrsToList (_: s: s.port) cfg.packageSites)
    ++ (lib.mapAttrsToList (_: s: s.port) cfg.ciSites);

  mkNginxHost = root: site: {
    listen = [
      {
        addr = "0.0.0.0";
        inherit (site) port;
      }
    ];
    inherit root;
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
    ciSites = lib.mkOption {
      type = lib.types.attrsOf ciSitesModule;
      default = { };
    };

  };

  config = lib.mkIf (cfg.packageSites != { } || cfg.ciSites != { }) {

    systemd.tmpfiles.rules = [
      "d /var/www 2775 root woodpecker-deploy - - "
    ];

    networking.firewall.allowedTCPPorts = allPorts;
    services.nginx = {
      enable = true;
      virtualHosts = lib.mkMerge [
        (builtins.mapAttrs (
          _: site:
          mkNginxHost (
            if site.subfolder == "" then site.package else "${site.package}/${site.subfolder}"
          ) site
        ) cfg.packageSites)

        (builtins.mapAttrs (name: site: mkNginxHost "/var/www/${name}" site) cfg.ciSites)
      ];
    };

  };
}
