{
  config,
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
in
{
  options = {
    modules.quickshell.enable = lib.mkEnableOption "quickshell";
  };

  config = lib.mkIf cfg.enable {
    programs.quickshell.enable = true;
    home.file.".config/quickshell/shell.qml".source = config.lib.file.mkOutOfStoreSymlink ./shell.qml;
  };
}
