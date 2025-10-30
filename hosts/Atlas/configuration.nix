{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # modules.virt.enable = true;
  modules.hyprland.enable = true;
  modules.steam.enable = true;
  modules.nvidia.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [

    memtester
    screen
    ncdu
    smartmontools
  ];

  monitors = [
    {
      name = "DP-1";
      width = 2560;
      height = 1440;
      primary = true;
      refreshRate = 120;
    }
    {
      name = "HDMI-1";
      width = 1920;
      height = 1080;
      position = "2560x0";
      refreshRate = 75;
    }
  ];
  system.stateVersion = "25.05"; # Did you read the comment?
}
