{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.homepage;
  vars = config.homelab;

  mkGlance = host: metric: {
    widget = {
      type = "glances";
      inherit metric;
      url = "http://${host}:${toString vars.ports.glances}";
      version = 4;
    };
  };

in

{
  options.homelab.services.homepage = {
    enable = lib.mkEnableOption "Enable the Homepage dashboard";

    groups = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.attrs);
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [ 8082 ];

    services.homepage-dashboard = {
      enable = true;

      allowedHosts = lib.concatStringsSep "," [
        vars.baseDomain
        "${vars.baseDomain}:8082"
        "127.0.0.1:8082"
        vars.ingressIP
        "${vars.ingressIP}:8082"
      ];

      settings = {
        title = "PeaterPita Home";
        theme = "dark";
        color = "slate";
        headerStyle = "clean";

        layout = [
          {
            "Monitoring" = {
              style = "row";
              columns = 4;
            };
          }

          {
            "Media" = {
              style = "row";
              columns = 3;
            };
          }
          {
            "Infrastructure" = {
              style = "row";
              columns = 3;
            };
          }
          {
            "Security" = {
              style = "row";
              columns = 3;
            };
          }
        ];
      };

      widgets = [
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
