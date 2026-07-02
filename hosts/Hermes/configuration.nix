{
  config,
  inputs,
  lib,
  ...
}:

#############################################################
#                  Potentially usful docs                   #
# https://microvm-nix.github.io/microvm.nix/interfaces.html #
#############################################################

let
  cfg = config.homelab;

  utils = import ../../utils/utils.nix { inherit lib; };
in

{
  imports = [
    inputs.microvm.nixosModules.microvm
  ]
  ++ utils.filesFromDirRec ../../modules/servers;

  microvm = {
    hypervisor = "qemu";
    mem = 1024;
    vcpu = 2;
    vsock.cid = 3;

    interfaces = [
      {
        type = "tap";
        id = "vm-hermes";
        mac = "02:00:00:00:01:01";
      }
    ];
    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }

      {
        source = "/var/lib/GeoIP";
        mountPoint = "/var/lib/GeoIP";
        tag = "geoip";
        proto = "virtiofs";
      }

      {
        source = "/run/secrets/rendered";
        mountPoint = "/run/host-secrets";
        tag = "host-secrets";
        proto = "virtiofs";
      }
    ];

    volumes = [
      {
        mountPoint = "/var";
        image = "hermes-var.img";
        size = 1000;
      }
    ];
  };

  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks."10-lan" = {
      matchConfig.MACAddress = "02:00:00:00:01:01";
      networkConfig = {
        Address = "${cfg.ingressIP}/24";
        Gateway = cfg.gatewayIP;
        DNS = "127.0.0.1";
      };
    };
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4UunpG+zwcD8K6yKG0Tl9DOG4fbl+tb0MjIVIOGNyp"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.resolved.settings.Resolve = {
    DNS = [
      "127.0.0.1"
      "1.1.1.1"
    ];
    DNSStubListener = "no";
  };

  # services.resolved.extraConfig = ''
  #   DNS=1.1.1.1
  #   DNSStubListener=no
  # '';

  homelab.services = {
    monitoring = {
      glances.enable = true;
      node-exporter.enable = true;
      alloy = {
        enable = true;
        extraConfig = ''
          local.file_match "traefik_access" {
              path_targets = [{"__path__" = "/var/log/traefik/access.json"}]
            }

            loki.source.file "traefik_access" {
              targets    = local.file_match.traefik_access.targets
              forward_to = [loki.process.traefik.receiver]
            }

            loki.process "traefik" {
              stage.json {
                expressions = {
                  client_ip    = "ClientHost",
                  status       = "DownstreamStatus",
                  method       = "RequestMethod",
                  path         = "RequestPath",
                  request_host = "RequestHost",
                  service      = "ServiceName",
                  router       = "RouterName",
                  duration     = "Duration",
                  size         = "DownstreamContentSize",
                  user_agent   = "request_User-Agent",
                  referer      = "request_Referer",
                }
              }

              stage.geoip {
                db      = "/var/lib/GeoIP/GeoLite2-City.mmdb"
                source  = "client_ip"
                db_type = "city"
              }

              stage.geoip {
                db      = "/var/lib/GeoIP/GeoLite2-ASN.mmdb"
                source  = "client_ip"
                db_type = "asn"
              }

              stage.labels {
                values = {
                  status_code     = "status",
                  method          = "",
                  service         = "",
                  geoip_country   = "geoip_country_name",
                  geoip_city      = "geoip_city_name",
                  asn_org         = "geoip_autonomous_system_organization",
                }
              }

              stage.structured_metadata {
                values = {
                  client_ip       = "",
                  path            = "",
                  request_host    = "",
                  router          = "",
                  user_agent      = "",
                  referer         = "",
                  geoip_latitude  = "geoip_location_latitude",
                  geoip_longitude = "geoip_location_longitude",
                  asn             = "geoip_autonomous_system_number",
                  asn_org         = "geoip_autonomous_system_organization",
                  duration        = "",
                  size            = "",
                }
              }

              stage.static_labels {
                values = {
                  job  = "traefik-access",
                  host = "Hermes",
                }
              }

              forward_to = [loki.write.default.receiver]
            }

        '';
      };
    };
    adguard = {
      enable = true;
      rewrites = [
        {
          domain = "*.${cfg.baseDomain}";
          answer = cfg.ingressIP;
        }
        {
          domain = cfg.baseDomain;
          answer = cfg.ingressIP;
        }
      ];
    };

    traefik = {
      enable = true;
      environmentFile = "/run/host-secrets/traefik.env";
    };
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  system.stateVersion = "25.11";
}
