{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.glances;
in
{
  options.homelab.services.glances = {
    enable = lib.mkEnableOption "Enable Glances";
    port = lib.mkOption { default = 61208; };
  };

  config = lib.mkIf cfg.enable {
    services.glances = {
      enable = true;
      openFirewall = true;
      port = cfg.port;
    };
  };
}
