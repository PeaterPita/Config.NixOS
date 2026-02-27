{
  config,
  lib,
  pkgs,
  ...
}:

###################################################################################################################################
#                                        Lots of inspiration drawn from LongerHV config:                                          #
# https://github.com/LongerHV/nixos-configuration/blob/e4a0a7e1018195f29d027b178013061efb5a8f8a/modules/nixos/homelab/traefik.nix #
###################################################################################################################################

let
  cfg = config.homelab.services.traefik;
  vars = config.homelab;

  serviceSubmodule = lib.types.submodule {
    options = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "IP address of the service";
      };

      port = lib.mkOption {
        type = lib.types.port;
        description = "Port of the backend service";
      };

      middlewares = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };

  mkRouter = name: value: {
    rule = "Host(`${name}.${vars.baseDomain}`)";
    service = "${name}";
    entryPoints = [ "websecure" ];
    tls = { };
    middlewares = value.middlewares;
  };

  mkService = name: value: {
    loadBalancer.servers = [ { url = "http://${value.host}:${toString value.port}"; } ];
  };

in

{
  options.homelab.services.traefik = {
    enable = lib.mkEnableOption "Enable the Traefik Reverse Proxy";

    services = lib.mkOption {
      type = lib.types.attrsOf serviceSubmodule;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.traefik = {
      enable = true;

      staticConfigOptions = {
        api.dashboard = true;
        entryPoints = {
          web = {
            address = ":80";
            http.redirections.entryPoint.to = "websecure";
            http.redirections.entryPoint.scheme = "https";
          };
          websecure = {
            address = ":443";
          };
        };
      };

      dynamicConfigOptions = {

        http = {

          routers = lib.mkMerge [
            (builtins.mapAttrs mkRouter cfg.services)
            {

              api = {
                rule = "Host(`traefik.${vars.baseDomain}`)";
                service = "api@internal";
                tls = { };
                entryPoints = [
                  "websecure"
                ];
              };

              home = {
                rule = "Host(`${vars.baseDomain}`)";
                service = "home-backend";
                tls = { };
                entryPoints = [
                  "websecure"
                ];
              };

            }
          ];

          services = lib.mkMerge [
            (builtins.mapAttrs mkService cfg.services)

            {
              home-backend = {
                loadBalancer.servers = [ { url = "http://${vars.coreIP}:8082"; } ];
              };
            }
          ];
          middlewares = {
            internal-only.ipWhiteList.sourceRange = [
              "127.0.0.1/32"
              "192.168.0.0/24"
            ];
          };

        };
      };

    };

  };

}
