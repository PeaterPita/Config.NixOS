(import ../../utils/mkService.nix) {
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
    {
      pkgs,
      config,
      cfg,
      ...
    }:
    let
      json_port = config.homelab.services.monitoring.json-exporter.port;
    in
    {
      sops.secrets."jellyfin/api_key".owner = "json-exporter";
      homelab.services = {
        backup.paths = [
          "/var/lib/jellyfin/config"
          "/var/lib/jellyfin/data"
        ];

        homepage.disks = [ "/mnt/media/movies" ];

        monitoring.json-exporter.modules.jellyfin = {
          http_client_config.http_headers = {
            "X-Emby-Token" = {
              files = [ config.sops.secrets."jellyfin/api_key".path ];
            };
          };
          metrics = [
            {
              name = "jellyfin_sessions";
              type = "object";
              help = "Active Jellyfin Sessions";
              path = "{ [*] }";
              labels = {
                user = "{ .UserName }";
                client = "{ .Client}";
                device = "{ .DeviceName }";
                remote_ip = "{ .RemoteEndPoint}";
              };
              values.active = "1";
            }

            {
              name = "jellyfin_playing";
              type = "object";
              help = "Sessions with active playback";
              path = "{ [?(@.NowPlayingItem)] }";
              labels = {
                user = "{ .UserName }";
                client = "{ .Client}";
                item = "{ .NowPlayingItem.Name }";
                series = " { .NowPlayingItem.SeriesName }";
                media_type = "{ .NowPlayingItem.Type }";
              };
              values = {
                position_ticks = "{ .PlayState.PositionTicks }";
                runtime_ticks = "{ .NowPlayingItem.RunTimeTicks}";
              };
            }

          ];
        };
      };

      services.prometheus.scrapeConfigs = [
        {
          job_name = "jellyfin_sessions";
          metrics_path = "/probe";
          params = {
            module = [ "jellyfin" ];
            target = [ "http://127.0.0.1:${toString cfg.port}/Sessions?ActiveWithinSeconds" ];

          };
          static_configs = [
            {
              targets = [ "127.0.0.1:${toString json_port}" ];
              labels.host = config.networking.hostName;
            }
          ];
        }
      ];

      environment.systemPackages = with pkgs; [
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
      ];

      services.jellyfin.enable = true;
    };
}
