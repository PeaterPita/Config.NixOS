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

  autoRouteServices = lib.filterAttrs (
    name: service: service ? routing && service.routing.enable
  ) vars.services;

  mkService = name: service: {
    loadBalancer.servers = [
      { url = "http://${service.routing.host}:${toString service.routing.port}"; }
    ];
  };

  mkRouter = name: service: {
    rule = "Host(`${service.domain}.${vars.baseDomain}`)";
    service = name;
    entryPoints = [ "websecure" ];
    middlewares = [
      "rate-limit"
    ]
    ++ service.routing.middlewares
    ++ lib.optional service.routing.protected "authelia";
  };

in

{
  options.homelab.services.traefik = {
    enable = lib.mkEnableOption "Enable the Traefik reverse proxy";

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
      8082
    ];

    systemd.tmpfiles.rules = [ "d /var/log/traefik 0755 traefik traefik - - " ];

    services.traefik = {
      enable = true;

      environmentFiles = lib.optional (cfg.environmentFile != null) cfg.environmentFile;

      staticConfigOptions = {
        api.dashboard = true;

        accessLog = {
          format = "json";
          filePath = "/var/log/traefik/access.json";
          fields.headers = {
            defaultMode = "keep";

          };

          bufferingSize = 100;
        };

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

          metrics.address = ":8082";

        };

        metrics.prometheus = {
          entryPoint = "metrics";
          addRoutersLabels = true;
          addServicesLabels = true;
        };

        certificatesResolvers.letsencrypt.acme = {
          email = "$ACME_EMAIL";
          storage = "${config.services.traefik.dataDir}/acme.json";
          dnsChallenge = {
            provider = "cloudflare";
            resolvers = [
              "1.1.1.1:53"
              "8.8.8.8:53"
            ];
          };
        };
      };

      dynamicConfigOptions.http = {
        routers = lib.mkMerge [
          (builtins.mapAttrs mkRouter autoRouteServices)

          {
            api = {
              rule = "Host(`traefik.${vars.baseDomain}`)";
              service = "api@internal";
              entryPoints = [ "websecure" ];
              tls.certResolver = "letsencrypt";
              middlewares = [
                # "internal-only"
                "authelia"
              ];
            };

            authelia = {
              rule = "Host(`auth.${vars.baseDomain}`)";
              entryPoints = [ "websecure" ];
              service = "authelia";
              tls.certResolver = "letsencrypt";
            };

            adguard = {
              rule = "Host(`adguard.${vars.baseDomain}`)";
              entryPoints = [ "websecure" ];
              service = "adguard";
              tls.certResolver = "letsencrypt";
              middlewares = [ "authelia" ];
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
          (builtins.mapAttrs mkService autoRouteServices)

          {
            adguard.loadBalancer.servers = [
              { url = "http://${vars.ingressIP}:${toString vars.services.adguard.port}"; }
            ];

            authelia.loadBalancer.servers = [
              { url = "http://${vars.coreIP}:${toString vars.services.authelia.port}"; }
            ];

            root-domain.loadBalancer.servers = [
              { url = "http://${vars.coreIP}:${toString vars.services.portfolio.port}"; }
            ];
          }
        ];

        middlewares = {
          internal-only.ipAllowList.sourceRange = [
            "127.0.0.1/32"
            "192.168.0.0/24"
            "100.64.0.0/10"
          ];

          rate-limit.rateLimit = {
            average = 100;
            burst = 50;
            period = "1s";
          };

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
