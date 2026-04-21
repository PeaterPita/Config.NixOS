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
        description = "Require Authentik SSO to access this service";
      };
    };
  };

  mkRouter = name: value: {
    rule = "Host(`${name}.${vars.baseDomain}`)";
    service = name;
    entryPoints = [ "websecure" ];
    tls.certResolver = "letsencrypt";
    middlewares = value.middlewares ++ lib.optional value.protected "authentik";
  };

  mkPublicRouter = name: value: {
    rule = "Host(`${name}.${vars.baseDomain}`)";
    service = "public-${name}";
    entryPoints = [ "websecure" ];
    tls.certResolver = "letsencrypt";
    middlewares = value.middlewares ++ lib.optional value.protected "authentik";
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
      description = "Internal services routed by baseDomain";
    };

    publicServices = lib.mkOption {
      type = lib.types.attrsOf serviceSubmodule;
      default = { };
      description = "Public services routed by publicDomain";
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

        entryPoints = {
          web = {
            address = ":80";
            http.redirections.entryPoint = {
              to = "websecure";
              scheme = "https";
            };
          };
          websecure.address = ":443";
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
          (builtins.mapAttrs mkRouter cfg.services)

          (lib.mapAttrs' (
            name: value: lib.nameValuePair "public-${name}" (mkPublicRouter name value)
          ) cfg.publicServices)

          {
            api = {
              rule = "Host(`traefik.${vars.baseDomain}`)";
              service = "api@internal";
              entryPoints = [ "websecure" ];
              tls.certResolver = "letsencrypt";
              middlewares = [ "internal-only" ];
            };

            portfolio = {
              rule = "Host(`${vars.baseDomain}`)";
              service = "portfolio-backend";
              entryPoints = [ "websecure" ];
              tls.certResolver = "letsencrypt";
            };
          }
        ];

        services = lib.mkMerge [
          (builtins.mapAttrs mkService cfg.services)
          (lib.mapAttrs' (
            name: value: lib.nameValuePair "public-${name}" (mkService name value)
          ) cfg.publicServices)

          {
            portfolio-backend.loadBalancer.servers = [ { url = "http://${vars.coreIP}:3005"; } ];
          }
        ];

        middlewares = {
          internal-only.ipWhiteList.sourceRange = [
            "127.0.0.1/32"
            "192.168.0.0/24"
            "100.64.0.0/10"
          ];

          authentik.forwardAuth = {
            address = "http://${vars.coreIP}:${toString vars.services.authentik.port}/outpost.goauthentik.io/auth/traefik";
            trustForwardHeader = true;
            authResponseHeaders = [
              "X-authentik-username"
              "X-authentik-groups"
              "X-authentik-email"
              "X-authentik-name"
              "X-authentik-uid"
              "X-authentik-jwt"
              "X-authentik-meta-jwks"
              "X-authentik-meta-outpost"
              "X-authentik-meta-provider"
              "X-authentik-meta-app"
              "X-authentik-meta-version"
            ];
          };
        };

      };
    };

  };
}
