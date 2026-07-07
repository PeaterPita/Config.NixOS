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
    _: service: service ? routing && service.routing.enable
  ) vars.services;

  mkService = _: service: {
    loadBalancer = {
      servers = [
        { url = "http://${service.routing.host}:${toString service.routing.port}"; }
      ];
    }
    // lib.optionalAttrs (service.routing.healthPath != null) {
      healthCheck.path = service.routing.healthPath;
    };
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

    services.logrotate = {
      enable = true;
      settings."/var/log/traefik/access.json" = {
        frequency = "daily";
        rotate = 2;
        size = "100M";
        compress = true;
        copytruncate = true;
      };
    };

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
            forwardedHeaders.trustedIPs = [
              "173.245.48.0/20"
              "103.21.244.0/22"
              "103.22.200.0/22"
              "103.31.4.0/22"
              "141.101.96.0/19"
              "108.162.192.0/18"
              "190.93.240.0/20"
              "188.114.96.0/20"
              "197.234.240.0/22"
              "198.41.128.0/17"
              "162.158.0.0/15"
              "104.16.0.0/13"
              "104.24.0.0/14"
              "172.64.0.0/13"
              "131.0.72.0/22"
              "2400:cb00::/32"
              "2606:4700::/32"
              "2803:f800::/32"
              "2405:b500::/32"
              "2405:8100::/32"
              "2a06:98c0::/29"
              "2c0f:f248::/32"
            ];
          };

          metrics.address = ":8082";

        };

        metrics.prometheus = {
          entryPoint = "metrics";
          addRoutersLabels = true;
          addServicesLabels = true;
          buckets = [
            0.01
            0.05
            0.1
            0.25
            0.5
            1.0
            2.5
            5.0
            10.0
          ];
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
