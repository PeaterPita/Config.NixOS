{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.nvidia;
in
{
  options = {
    modules.nvidia.enable = lib.mkEnableOption "nvidia";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true; # <- nvidia-smi not included
    boot.blacklistedKernelModules = [ "nouveau" ];
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true; # Tried both true and false
      package = config.boot.kernelPackages.nvidiaPackages.beta; # Tried Stable, Beta, Production
    };
  };
}
