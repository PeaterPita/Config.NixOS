{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./common-programs.nix ];
  services.openssh.enable = true;
  modules.tailscale.enable = true;

  users.defaultUserShell = pkgs.zsh;

  modules.networking.enable = true;
  modules.sound.enable = true;

  services.xserver.enable = true;
  services.journald.extraConfig = "SystemMaxUse=100M";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 10; # <- Make it so that the generation choice doesnt appear UNLESS key is held during boot sequence.
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

  # Default background image + color scheme
  # stylix.enable = true;
  # stylix.image = pkgs.fetchurl {
  #   url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nix-wallpaper-nineish-catppuccin-macchiato-alt.png?raw=true";
  #   hash = "sha256-OUT0SsToRH5Zdd+jOwhr9iVBoVNUKhUkJNBYFDKZGOU=";
  # };
  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/brewer.yaml";

  services.greetd = {

    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland --remember";
        user = "peaterpita";
      };
    };
  };

  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.iosevka
  ];

  time.timeZone = "Europe/London";
  time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_GB.UTF-8";

  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';

    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 14d";
  };

  environment.defaultPackages = [ ]; # Remove all preinstalled packages

}
