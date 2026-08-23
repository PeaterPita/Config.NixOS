{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.anyrun;
  package = pkgs.unstable.anyrun;
in
{
  options = {
    modules.anyrun.enable = lib.mkEnableOption "anyrun";
  };
  ###############################################################################################
  # Anyrun default config: https://github.com/anyrun-org/anyrun/blob/master/examples/config.ron #
  ###############################################################################################

  config = lib.mkIf cfg.enable {
    programs.anyrun = {
      enable = true;
      inherit package;
      config = {
        x.fraction = 0.5;
        y.fraction = 0.3;
        width.fraction = 0.3;

        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = true;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = null;

        plugins = [
          "${package}/lib/libapplications.so"
          "${package}/lib/librink.so"
        ];
      };
    };
  };
}
