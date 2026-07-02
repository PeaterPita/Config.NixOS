(import ../../utils/mkService.nix) {
  name = "navidrome";
  port = 4533;
  domain = "music";

  routing = {
    protected = true;
    healthPath = "/";
  };

  homepage = {
    name = "Navidrome";
    group = "Apps";
    description = "Music Streaming";
  };

  extraConfig =
    {
      vars,
      pkgs,
      cfg,
      ...
    }:
    {
      users.users.navidrome.extraGroups = [ "media" ];

      homelab.services = {
        backup.dbFiles.navidrome = "/var/lib/navidrome/navidrome.db";
        homepage.disks = [ "/mnt/media/music" ];

        authelia.rules = [
          {
            domain = [ "${cfg.domain}.${vars.baseDomain}" ];
            policy = "bypass";
            ############################################################
            #  Fixes to allow external players to still authenticate   #
            #      https://github.com/jeffvli/feishin/issues/1976      #
            ############################################################
            resources = [
              "^/share(/.*)?$"
              "^/auth/.*$"
              "^/rest/.*$"
              "^/api/.*$"
            ];
          }
          {
            domain = [
              "${cfg.domain}.${vars.baseDomain}"
            ];
            policy = "one_factor";
            subject = [
              "group:admin"
              "group:music"
            ];
          }
        ];
      };

      ################################################################################
      #                      https://github.com/LumePart/Explo                       #
      # https://chhs1.github.io/blog/2026/01/22/self-hosted-discovery-playlists.html #
      ################################################################################

      services.navidrome = {
        enable = true;
        openFirewall = true;
        plugins = with pkgs.navidromePlugins; [
          listenbrainz-daily-playlist
        ];
        settings = {
          MusicFolder = "/mnt/media/music";
          Address = "0.0.0.0";
          Port = cfg.port;
          EnableSharing = true;

          Plugins = {
            Enabled = true;
          };
          ExtAuth.TrustedSources = "${vars.ingressIP}/32";
          ExtAuth.LogoutURL = "https://auth.${vars.baseDomain}/logout";
        };
      };

    };
}
