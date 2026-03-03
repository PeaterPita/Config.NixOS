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
      type = lib.types.attrsOf (lib.types.listOf lib.types.attrs);
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8082 ];

    sops.secrets."proxmox-api-token" = {
      sopsFile = ../../../secrets/services.yaml;
    };

    sops.templates."homepage.env".content = ''
      HOMEPAGE_VAR_PROXMOX_TOKEN=${config.sops.placeholder."proxmox-api-token"}
    '';

    services.homepage-dashboard = {
      enable = true;
      environmentFile = config.sops.templates."homepage.env".path;

      allowedHosts = lib.concatStringsSep "," [
        vars.baseDomain
        "${vars.baseDomain}:8082"
        "127.0.0.1:8082"
        vars.ingressIP
      ];

      settings = {
        title = "PeaterPita Home";
        theme = "dark";
      };
      widgets = [

        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
          };

        }

      ];

      services = lib.mapAttrsToList (name: items: { "${name}" = items; }) cfg.groups;

    };
  };
}
