{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    quickshell
  ];

  qt.enable = true;

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
    package = pkgs.wireshark-qt;
  };

  services.flatpak.enable = true;

  modules = {
    # virt.enable = true;

    obs.enable = true;
    plasma.enable = true;
    steam.enable = true;
    nvidia.enable = true;
    hardware = {
      g502.enable = true;
      qmkBoards.enable = true;
      camera.enable = true;
    };
  };
  virtualisation.docker.enable = true;

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
