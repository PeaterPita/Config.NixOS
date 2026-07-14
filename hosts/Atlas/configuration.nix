{
  pkgs,
  ...
}:

{
  boot.kernelModules = [ "ntsync" ];

  services.udev.packages = with pkgs; [
    heimdall
  ];

  system.isDesktop = true;

  services.flatpak.enable = true;

  services.greetd.settings.initial_session = {
    command = "uwsm start -e -D Hyprland hyprland.desktop";
    user = "peaterpita";
  };

  modules = {
    kdeConnect.enable = true;
    # virt.enable = true;

    obs.enable = true;
    hyprland.enable = true;
    steam.enable = true;
    sunshine.enable = true;
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
