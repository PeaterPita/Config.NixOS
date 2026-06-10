{
  name,
  port,
  domain ? name,

  homepage ? null,
  routing ? null,

  extraOptions ? (_: { }),
  extraConfig,

}:

{
  config,
  lib,
  pkgs,
  ...
}:

let
  vars = config.homelab;
  cfg = vars.services.${name};

in

{

  options.homelab.services.${name} = {
    enable = lib.mkEnableOption "Enable ${name} (mkSerivce)";
    port = lib.mkOption { default = port; };
    domain = lib.mkOption { default = domain; };
  }
  // (lib.optionalAttrs (routing != null) {
    routing = {
      enable = lib.mkOption { default = true; };
      host = lib.mkOption { default = vars.coreIP; };
      port = lib.mkOption { default = routing.port or port; };
      protected = lib.mkOption { default = routing.protected or false; };
      middlewares = lib.mkOption { default = routing.middlewares or [ ]; };
      healthPath = lib.mkOption { default = routing.healthPath or null; };
    };

  })
  // (extraOptions { inherit lib pkgs; });

  config = lib.mkIf cfg.enable (
    lib.mkMerge [

      {
        networking.firewall.allowedTCPPorts = [ cfg.port ];
      }

      (lib.optionalAttrs (homepage != null) {
        homelab.services.homepage.groups.${homepage.group} = [
          {
            ${name} = {
              icon = "${name}.png";
              href = "https://${cfg.domain}.${vars.baseDomain}";
              description = homepage.description;

              ping = "http://127.0.0.1:${toString cfg.port}";
            };
          }
        ];
      })

      (extraConfig {
        inherit
          cfg
          vars
          config
          pkgs
          lib
          ;
      })
    ]
  );
}
