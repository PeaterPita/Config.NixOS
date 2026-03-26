{ config, pkgs, ... }:

{
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  system.isDesktop = true;

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
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
    niri.enable = true;
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
