{
  pkgs,
  ...
}:

{
  imports = [ ./common-programs.nix ];
  services.journald.extraConfig = "SystemMaxUse=100M";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.memtest86.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 0; # <- Make it so that the generation choice doesnt appear UNLESS key is held during boot sequence.
  };

  services.resolved.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
    };
  };
  boot = {
    kernel.sysctl."kernel.sysrq" = 1;
    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.systemd.enable = true;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
    ];
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    settings = {
      substituters = [
        "https://cache.peaterpita.com"
        "https://noctalia.cachix.org"
      ];
      trusted-public-keys = [
        "cache.peaterpita.com-1:HFufcQT6KtSMSJKFu9UCDQ2cSD6k0LmjvAMxm4KFciU="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];

      trusted-users = [ "peaterpita" ];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    registry.temps.to = {
      type = "git";
      url = "git+ssh://git@github.com/PeaterPita/nixtemplates.git";
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

}
