(import ../../utils/mkService.nix) {
  name = "woodpecker";
  port = 3007;
  domain = "ci";

  routing = {
    protected = true;

  };

  homepage = {
    icon = "woodpecker-ci";
    group = "Apps";
    description = "CI/CD";

  };

  extraConfig =
    {
      config,
      lib,
      pkgs,
      vars,
      cfg,
      ...
    }:

    let
      agentPort = 34582;
    in
    {

      homelab.services.authelia.rules = [
        {
          domain = [ "${cfg.domain}.${vars.baseDomain}" ];
          policy = "bypass";
          resources = [
            "^/api/badges/.*$"
            "^/api/hook.*$"
          ];
        }
        {
          domain = [
            "${cfg.domain}.${vars.baseDomain}"
          ];
          policy = "one_factor";
          subject = [ "group:admin" ];
        }
      ];

      sops = {
        secrets = {
          "woodpecker/github_client" = { };
          "woodpecker/github_secret" = { };
          "woodpecker/agent_secret" = { };
          "woodpecker/grpc_secret" = { };
        };
        templates = {

          "woodpecker-server.env".content = ''
            WOODPECKER_GITHUB_CLIENT=${config.sops.placeholder."woodpecker/github_client"}
            WOODPECKER_GITHUB_SECRET=${config.sops.placeholder."woodpecker/github_secret"}
            WOODPECKER_AGENT_SECRET=${config.sops.placeholder."woodpecker/agent_secret"}
            WOODPECKER_GRPC_SECRET=${config.sops.placeholder."woodpecker/grpc_secret"}
          '';

          "woodpecker-agent.env".content = ''
            WOODPECKER_AGENT_SECRET=${config.sops.placeholder."woodpecker/agent_secret"}
          '';
        };
      };

      services.woodpecker-server = {
        enable = true;
        environmentFile = [ config.sops.templates."woodpecker-server.env".path ];
        environment = {
          WOODPECKER_OPEN = "true";
          WOODPECKER_HOST = "https://${cfg.domain}.${vars.baseDomain}";
          WOODPECKER_SERVER_ADDR = ":${toString cfg.port}";
          WOODPECKER_GRPC_ADDR = ":${toString agentPort}";
          WOODPECKER_GITHUB = "true";
        };
      };

      systemd.services.woodpecker-agent-local.serviceConfig = {
        MemoryDenyWriteExecute = lib.mkForce false;
        SystemCallFilter = lib.mkForce [ ];
        ReadWritePaths = [ "/var/www" ];
      };

      users.groups.woodpecker-deploy = { };

      services.woodpecker-agents.agents.local = {
        enable = true;
        environmentFile = [ config.sops.templates."woodpecker-agent.env".path ];
        extraGroups = [ "woodpecker-deploy" ];
        path = with pkgs; [
          git
          git-lfs
          nix
          bash
        ];
        environment = {
          WOODPECKER_SERVER = "localhost:${toString agentPort}";
          WOODPECKER_BACKEND = "local";
        };

      };

    };

}
