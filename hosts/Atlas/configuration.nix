{
  pkgs,
  lib,
  ...
}:

{
  boot.kernelModules = [ "ntsync" ];

  environment.systemPackages = with pkgs; [
    parsec-bin
    typescript
    postman
    inkscape
  ];

  system.isDesktop = true;

  services.flatpak.enable = true;

  modules = {
    kdeConnect.enable = true;
    # virt.enable = true;

    obs.enable = true;
    wireshark.enable = true;
    plasma.enable = true;
    hyprland.enable = true;
    steam.enable = true;
    nvidia.enable = true;
    hardware = {
      g502.enable = true;
      qmkBoards.enable = true;
      camera.enable = true;
    };
  };
  virtualisation.docker.enable = true;

  services.displayManager.sddm.enable = lib.mkForce false;

  monitors = [
    {
      name = "DP-1";
      width = 2560;
      height = 1440;
      position = "0x0";
      primary = true;
      refreshRate = 120;
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      position = "2560x0";
      refreshRate = 75;
    }
  ];
  system.stateVersion = "25.05"; # Did you read the comment?
}
