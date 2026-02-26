{
  pkgs,
  config,
  ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  services.qemuGuest.enable = true;

  homelab.services = {
    # authentik.enable = true;
    homepage.enable = true;
    # nextcloud.enable = true;
    jellyfin.enable = true;
    navidrome.enable = true;
    # vaultwarden.enable = true;
  };

  environment.systemPackages = with pkgs; [ nfs-utils ];

  fileSystems = {

    "/mnt/media/movies" = {
      device = "${config.homelab.storageIP}:/mnt/tank/Media/Movies";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout==600"
      ];

    };

    "/mnt/media/music" = {
      device = "${config.homelab.storageIP}:/mnt/tank/Media/Music";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout==600"
      ];

    };
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
