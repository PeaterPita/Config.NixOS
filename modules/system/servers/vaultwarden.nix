{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.vaultwarden;

in

{
  options.homelab.services.vaultwarden = {
    enable = lib.mkEnableOption "Enable the Vaultwarden password management service";
  };

  config = lib.mkIf cfg.enable {

    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers = {
      "vaultwarden" = {
        image = "vaultwarden/server:latest";
        ports = [ "8222:80" ];
        environment = {
          SIGNUPS_ALLOWED = "true";
        };
        volumes = [ "/var/lib/vaultwarden:/data" ];
      };
    };

  };
}
