{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:

############################################################
#                          Docs:                           #
#  https://quickshell.org/docs/v0.2.1/guide/introduction/  #
############################################################
let
  cfg = config.modules.quickshell;

  modulesPath = ./Modules;
  hostPath = ./. + "/${osConfig.networking.hostName}";

  finalConfig = pkgs.runCommand "qs-merged" { } ''
    mkdir -p $out
    cp -r ${hostPath}/* $out/
    cp -r ${modulesPath}/* $out/
    pwd
  '';

in
{
  options = {
    modules.quickshell.enable = lib.mkEnableOption "quickshell";
  };

  config = lib.mkIf cfg.enable {
    programs.quickshell = {
      enable = true;
      configs.default = finalConfig;
      activeConfig = "default";
    };
  };
}
