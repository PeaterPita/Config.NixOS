{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.homepage;
  vars = config.homelab;

in

{
  options.homelab.services.homepage = {
    enable = lib.mkEnableOption "Enable the Homepage dashboard ";

    groups = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.attrs);
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8082 ];

    services.homepage-dashboard = {
      enable = true;
      allowedHosts = "home.arpa,homepage.${vars.baseDomain},${vars.baseDomain}:8082,127.0.0.1:8082";

      settings = {
        title = "PeaterPita Home";
        theme = "dark";
      };
      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
            disk = "/";
          };
        }

        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
          };

        }
      ];

      services = lib.mkMerge [
        (lib.mapAttrsToList (name: items: { "${name}" = items; }) cfg.groups)
        [

          # {
          #   "Games" = [
          #     {
          #       "Pterodactyl Panel" = {
          #         icon = "pterodactyl.png";
          #         href = "https://panel.home.arpa";
          #         description = "Minecraft server hosting";
          #         widget = {
          #           type = "pterodactyl";
          #           url = "http://192.168.1.Y";
          #           key = "";
          #         };
          #       };
          #     }
          #   ];
          # }

        ]
      ];

    };

  };
}
