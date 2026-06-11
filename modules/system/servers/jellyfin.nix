(import ../../../utils/mkService.nix) {
  name = "jellyfin";
  port = 8096;

  routing = {
    protected = false;
    healthPath = "/health";
  };

  homepage = {
    group = "Apps";
    description = "Movies & TV";
  };

  #############################################################
  #                       To look into                        #
  # https://jellyfin-jellyfin.mintlify.app/api/users/sessions #
  #############################################################
  extraConfig =
    { pkgs, ... }:
    {
      homelab.services.homepage.disks = [ "/mnt/media/movies" ];

      environment.systemPackages = with pkgs; [
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
      ];

      services.jellyfin.enable = true;
    };
}
