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
    gimp
  ];
  modules = {
    virt.enable = true;
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

  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    relay.enable = false;
    signal.relayHosts = [ "127.0.0.1" ];
  };

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
