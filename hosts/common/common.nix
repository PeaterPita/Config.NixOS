{
  pkgs,
  ...
}:

{
  imports = [ ./common-programs.nix ];
  users.defaultUserShell = pkgs.zsh;
  services.journald.extraConfig = "SystemMaxUse=100M";
  boot.kernelPackages = pkgs.linuxPackages_6_18;

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
  time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_GB.UTF-8";

  nixpkgs.config = {
    allowUnfree = true;
  };
  nix = {
    settings.trusted-users = [ "peaterpita" ];
    settings.auto-optimise-store = true;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    extraOptions = ''
      # keep-outputs = true
      # keep-derivations = true
    '';

    registry.temps.to = {
      type = "git";
      url = "git+ssh://git@github.com/PeaterPita/nixtemplates.git";
    };

    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 7d";
  };

}
