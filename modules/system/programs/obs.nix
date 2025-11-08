{
  config,
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
    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    security.polkit.enable = true;

    programs.obs-studio = {
      package = lib.mkIf config.modules.nvidia.enable (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );

      enable = true;
      # enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
      ];
    };
  };
}
