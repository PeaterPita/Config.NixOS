{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.sunshine;
in
{
  options = {
    modules.sunshine.enable = lib.mkEnableOption "sunshine";
  };

  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      package = pkgs.sunshine.override { cudaSupport = true; };
      openFirewall = true;
      capSysAdmin = true;
      autoStart = true;
      settings = {
        sunshine_name = config.networking.hostName;
        output_name = "DP-1";
      };
    };
  };
}
