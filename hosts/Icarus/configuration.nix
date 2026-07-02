{ ... }:

{
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  system.isDesktop = true;

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
    tlp.enable = false;
  };

  services.logind.settings.Login = {
    HandlePowerKey = "poweroff";
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  modules = {
    kdeConnect.enable = true;
    bluetooth.enable = true;
    hyprland.enable = true;
    steam.enable = true;
    wireshark.enable = true;
    networking = {
      enable = true;
      wireless.enable = true;
    };
  };

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
