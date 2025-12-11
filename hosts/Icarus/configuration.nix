{ config, pkgs, ... }:

{
  # services.displayManager.defaultSession = "hyprland";

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "lock";
    HandleLidSwitchDocked = "ignore";
  };

  modules.bluetooth.enable = true;
  modules.hyprland.enable = true;
  # modules.plasma.enable = true;
  modules.mongo.enable = true;

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      primary = true;
    }
  ];

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";
  system.stateVersion = "25.05"; # Did you read the comment?
}
