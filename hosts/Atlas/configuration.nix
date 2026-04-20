{
  pkgs,
  ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [ "ntsync" ];

  environment.systemPackages = with pkgs; [
    quickshell
    parsec-bin
  ];

  qt.enable = true;
  system.isDesktop = true;

  services.flatpak.enable = true;

  modules = {
    kdeConnect.enable = true;
    # virt.enable = true;

    obs.enable = true;
    wireshark.enable = true;
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
