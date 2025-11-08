{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.obs;
in
{
  options = {
    modules.obs.enable = lib.mkEnableOption "obs";
  };

  config = lib.mkIf cfg.enable {

    programs.obs-studio = {
      package = lib.mkIf osConfig.modules.nvidia.enable (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
      ];
    };
  };
}
