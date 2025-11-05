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
      # package = config.boot.kernelPackages.nvidiaPackages.beta; # Tried Stable, Beta, Production
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "580.95.05";
        ha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
        sha256_aarch64 = "sha256-zLRCbpiik2fGDa+d80wqV3ZV1U1b4lRjzNQJsLLlICk=";
        openSha256 = "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI=";
        settingsSha256 = "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14=";
        persistencedSha256 = "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg=";
      };
    };
  };
}
