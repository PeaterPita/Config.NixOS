{
  pkgs,
  ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.nameservers = [ "192.168.0.135" ];

  environment.systemPackages = with pkgs; [
    quickshell
    sqlitebrowser
  ];

  qt.enable = true;
  system.isDesktop = true;

  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      MusicFolder = "/mnt/music";
      Jukebox.Enabled = true;
      Address = "0.0.0.0";
    };
  };

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
