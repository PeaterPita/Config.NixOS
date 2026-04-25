{
  config,
  lib,
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
        description = "IP address of the backend service";
      };

      port = lib.mkOption {
        type = lib.types.port;
        description = "Port of the backend service";
      };

      middlewares = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };

      protected = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Require Authelia SSO to access this service";
      };
    };
  };

  mkRouter = name: value: {
    rule = "Host(`${name}.${vars.baseDomain}`)";
    service = name;
    entryPoints = [ "websecure" ];
    tls.certResolver = "letsencrypt";
    middlewares = value.middlewares ++ lib.optional value.protected "authelia";
  };

  mkService = name: value: {
    loadBalancer.servers = [ { url = "http://${value.host}:${toString value.port}"; } ];
  };

in

{
  options.homelab.services.traefik = {
    enable = lib.mkEnableOption "Enable the Traefik reverse proxy";

    services = lib.mkOption {
      type = lib.types.attrsOf serviceSubmodule;
      default = { };
      description = "Services routed by baseDomain";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.traefik = {
      enable = true;

      environmentFiles = lib.optional (cfg.environmentFile != null) cfg.environmentFile;

      staticConfigOptions = {
        api.dashboard = true;

        # accessLog = {
        #   format = "json";
        #   filePath = "/var/log/traefik/access.json";
        #   fields.headers = {
        #     defaultMode = "keep";
        #     Authorization = "drop";
        #   };
        # };

        entryPoints = {
          web = {
            address = ":80";
            http.redirections.entryPoint = {
              to = "websecure";
              scheme = "https";
            };
          };
          websecure = {
            address = ":443";
            http.tls.certResolver = "letsencrypt";
          };
        };

        certificatesResolvers.letsencrypt.acme = {
          email = "$ACME_EMAIL";
          storage = "${config.services.traefik.dataDir}/acme.json";
          dnsChallenge = {
            provider = "cloudflare";
            resolvers = [
              "${vars.upstreamDNS}:53"
              "8.8.8.8:53"
            ];
          };
        };
      };

      dynamicConfigOptions.http = {
        routers = lib.mkMerge [
          (builtins.mapAttrs mkRouter cfg.services)

          {
            api = {
              rule = "Host(`traefik.${vars.baseDomain}`)";
              service = "api@internal";
              entryPoints = [ "websecure" ];
              tls.certResolver = "letsencrypt";
              middlewares = [
                "internal-only"
                "authelia"
              ];
            };

            authelia = {
              rule = "Host(`auth.${vars.baseDomain}`)";
              entryPoints = [ "websecure" ];
              service = "authelia";
              tls.certResolver = "letsencrypt";
            };

            git = {
              rule = "Host(`git.${vars.baseDomain}`)";
              service = "noop@internal";
              entryPoints = [ "websecure" ];
              tls.certResolver = "letsencrypt";
              middlewares = [ "git-redirect" ];
            };

            portfolio = {
              rule = "Host(`${vars.baseDomain}`) || Host(`www.${vars.baseDomain}`)";
              service = "root-domain";
              entryPoints = [ "websecure" ];
              tls.certResolver = "letsencrypt";
            };
          }
        ];

        services = lib.mkMerge [
          (builtins.mapAttrs mkService cfg.services)

          {
            authelia.loadBalancer.servers = [
              { url = "http://${vars.coreIP}:${toString config.homelab.services.authelia.port}"; }
            ];

            root-domain.loadBalancer.servers = [
              { url = "http://${vars.coreIP}:${toString vars.services.portfolio.port}"; }
            ];
          }
        ];

        middlewares = {
          internal-only.ipWhiteList.sourceRange = [
            "127.0.0.1/32"
            "192.168.0.0/24"
            "100.78.0.0/10"
          ];

          git-redirect.redirectRegex = {
            regex = ".*";
            replacement = "https://github.com/PeaterPita";
            permanent = true;
          };

          authelia.forwardAuth = {
            address = "http://${vars.coreIP}:${toString config.homelab.services.authelia.port}/api/authz/forward-auth";
            trustForwardHeader = true;
            authResponseHeaders = [
              "Remote-User"
              "Remote-Groups"
              "Remote-Name"
              "Remote-Email"
            ];
          };

        };

      };
    };

  };
}
