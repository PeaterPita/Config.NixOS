{
  config,
  lib,
  ...
}:

# #########################################################################################################
# #https://www.reddit.com/r/selfhosted/comments/1ers52q/homepage_is_amazing_finally_a_command_center_for/ #
# #########################################################################################################
let
  cfg = config.homelab.services.homepage;
  vars = config.homelab;

  mkGlance = host: metric: {
    widget = {
      type = "glances";
      inherit metric;
      url = "http://${host}:${toString vars.services.glances.port}";
      version = 4;
    };
  };

in

{
  options.homelab.services.homepage = {
    enable = lib.mkEnableOption "Enable the Homepage dashboard";
    port = lib.mkOption { default = 8082; };

    groups = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.attrs);
      default = { };
    };

    disks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.homepage-dashboard = {
      enable = true;

      allowedHosts = lib.concatStringsSep "," [
        vars.baseDomain
        "${vars.baseDomain}:${toString cfg.port}"
        "127.0.0.1:${toString cfg.port}"
        vars.ingressIP
        "${vars.ingressIP}:${toString cfg.port}"
      ];

      settings = {
        title = "PeaterPita Home";
        theme = "dark";
        color = "slate";
        headerStyle = "boxedWidgets";

        layout = [
          {
            "Media" = {
              tab = "Apps";
            };
          }

          {
            "???" = {
              tab = "Media";
              header = false;
            };
          }

          {
            "Monitoring" = {
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
            "Security" = {
              tab = "System";
            };
          }
        ];
      };

      widgets = [
        {
          "glances" = {
            url = "http://${vars.coreIP}:${toString vars.services.glances.port}";
            version = 4;
            cpu = true;
            mem = true;
            cputemp = true;
            uptime = true;
          };
        }

        {
          "glances" = {
            url = "http://${vars.coreIP}:${toString vars.services.glances.port}";
            version = 4;
            cpu = false;
            mem = false;
            disk = [ "/" ] ++ cfg.disks;
          };
        }

        {
          "glances" = {
            url = "http://${vars.ingressIP}:${toString vars.services.glances.port}";
            version = 4;
            cpu = true;
            mem = true;
          };
        }
      ];

      services = [
        {
          "Monitoring" = [
            { "CPU" = mkGlance vars.coreIP "cpu"; }
            { "TEMP" = mkGlance vars.coreIP "sensor:Package id 0"; }
            { "RAM" = mkGlance vars.coreIP "memory"; }
            { "Hermes" = mkGlance vars.ingressIP "info"; }

          ];
        }
      ]
      ++ lib.mapAttrsToList (name: items: { "${name}" = items; }) cfg.groups;
    };

  };
}
