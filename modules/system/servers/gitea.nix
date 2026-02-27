{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.services.gitea;
  vars = config.homelab;
in

{
  options.homelab.services.gitea = {
    enable = lib.mkEnableOption "Personal Self-Hosted git";
  };

  config = lib.mkIf cfg.enable {

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "gitea" ];
      ensureUsers = [
        {
          name = "gitea";
          ensureDBOwnership = true;
        }
      ];
    };

    homelab.services.homepage.groups."Development" = [
      {
        Gitea = {
          icon = "gitea.png";
          href = "https://git.${vars.baseDomain}";
          ping = "http://127.0.0.1:${builtins.toString vars.ports.gitea}";
          widget = {
            type = "gitea";
            url = "http://127.0.0.1:${builtins.toString vars.ports.gitea}";
            key = "{{HOMEPAGE_VAR_GITEA_TOKEN}}";
          };
        };
      }
    ];

    networking.firewall.allowedTCPPorts = [
      3000
      22
    ];

    services.gitea = {
      enable = true;

      database = {
        type = "postgres";
        socket = "/run/postgresql";
      };

      settings = {
        server = {
          DOMAIN = "git.${vars.baseDomain}";
          ROOT_URL = "https://git.${vars.baseDomain}/";
          HTTP_PORT = vars.ports.gitea;
        };
        service.DISABLE_REGISTRATION = true;
      };
    };
  };

}
