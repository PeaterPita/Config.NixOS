(import ../../../../utils/mkService.nix) {
  name = "homepage";
  port = 8082;
  domain = "home";

  routing.protected = true;
  routing.healthPath = "/";

  extraOptions =
    { lib, ... }:
    {
      groups = lib.mkOption {
        type = lib.types.attrsOf (lib.types.listOf lib.types.attrs);
        default = { };
      };

      bookmarks = lib.mkOption {
        type = lib.types.attrsOf (lib.types.listOf lib.types.attrs);
        default = { };
      };

      disks = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };

  extraConfig =
    {
      vars,
      cfg,
      lib,
      ...
    }:
    # #########################################################################################################
    # #https://www.reddit.com/r/selfhosted/comments/1ers52q/homepage_is_amazing_finally_a_command_center_for/ #
    # #########################################################################################################
    let
      mkGlance = host: metric: {
        widget = {
          type = "glances";
          inherit metric;
          url = "http://${host}:${toString vars.services.monitoring.glances.port}";
          version = 4;
        };
      };
    in
    {
      homelab.services.authelia.rules = [
        {
          domain = [
            "${cfg.domain}.${vars.baseDomain}"
          ];
          policy = "one_factor";
          subject = [
            "group:admin"
            "group:home"
          ];
        }
      ];

      services.homepage-dashboard = {
        enable = true;

        allowedHosts = lib.concatStringsSep "," [
          "${cfg.domain}.${vars.baseDomain}"
          "${cfg.domain}.${vars.baseDomain}:${toString cfg.port}"
          vars.baseDomain
          "${vars.baseDomain}:${toString cfg.port}"
          "127.0.0.1:${toString cfg.port}"
          vars.ingressIP
          "${vars.ingressIP}:${toString cfg.port}"
        ];

        customCSS = builtins.readFile ./styles.css;
        settings = {
          title = "PeaterPita Home";
          theme = "dark";
          color = "slate";

          bookmarksStyle = "icons";
          headerStyle = "boxedWidgets";

          layout = [

            {
              "Apps" = {
                tab = "Home";
                style = "row";
                columns = 4;
              };
            }

            {
              "Personal" = {
                tab = "Home";
                style = "row";
                columns = 8;
              };
            }

            {
              "Graphs" = {
                tab = "System";
                style = "row";
                columns = 4;
                header = false;
              };
            }

            {
              "Infrastructure" = {
                tab = "System";
              };
            }

            {
              "Monitoring" = {
                tab = "System";
              };
            }

          ];
        };

        widgets =
          let
            glancesPort = toString vars.services.monitoring.glances.port;

          in
          [
            {
              "glances" = {
                url = "http://${vars.coreIP}:${glancesPort}";
                version = 4;
                cpu = true;
                mem = true;
                cputemp = true;
                uptime = true;
              };
            }

            {
              "glances" = {
                url = "http://${vars.coreIP}:${glancesPort}";
                version = 4;
                cpu = false;
                mem = false;
                disk = [
                  "/"
                ]

                ++ cfg.disks;
              };
            }

            {
              "glances" = {
                url = "http://${vars.ingressIP}:${glancesPort}";
                version = 4;
                cpu = true;
                mem = true;
              };
            }
          ];

        services = [
          {
            "Graphs" = [
              { "CPU" = mkGlance vars.coreIP "cpu"; }
              { "TEMP" = mkGlance vars.coreIP "sensor:Package id 0"; }
              { "RAM" = mkGlance vars.coreIP "memory"; }
              { "Networking" = mkGlance vars.coreIP "network:enp1s0"; }
              { "Hermes" = mkGlance vars.ingressIP "info"; }

            ];
          }

        ]
        ++ lib.mapAttrsToList (name: items: { "${name}" = items; }) cfg.groups;

        bookmarks = lib.mapAttrsToList (name: items: { "${name}" = items; }) cfg.bookmarks;

      };

    };
}
