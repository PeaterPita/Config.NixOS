{
  config,
  # osConfig,
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

  # modulesPath = ./Modules;
  # hostPath = ./. + "/${osConfig.networking.hostName}";

  # finalConfig = pkgs.runCommand "qs-merged" { } ''
  #   mkdir -p $out
  #   cp -r ${hostPath}/* $out
  #   cp -r ${modulesPath} $out/Modules
  #   pwd
  # '';

in
{
  options = {
    modules.quickshell.enable = lib.mkEnableOption "quickshell";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nerd-fonts.iosevka
      qt6.qt5compat
    ];

    xdg.configFile = {
      "quickshell".source =
        config.lib.file.mkOutOfStoreSymlink "/home/peaterpita/nixos/modules/home/quickshell";
    };

    programs.quickshell = {
      enable = true;
      activeConfig = "default";
    };
  };
}
