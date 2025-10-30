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

    # boot.initrd.kernelModules = [ "nvidia" ]; # <- causes a build failure
    boot.kernelModules = [ "nvidia" ]; # <- fine with and without

    hardware.graphics.enable = true; # <- nvidia-smi not included
    # boot.blacklistedKernelModules = [ "nouveau" ];
    # services.xserver.videoDrivers = [ "nvidia" ]; <- culprit, maybe
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true; # Tried both true and false
      package = config.boot.kernelPackages.nvidiaPackages.latest; # Tried Stable, Beta, Production
      nvidiaSettings = true;
    };
  };
}
