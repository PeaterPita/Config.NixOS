(import ../../utils/mkService.nix) {
  name = "cache";
  port = 21725;

  routing = {
    protected = false;
    middlewares = [ "internal-only" ];
  };

  extraConfig =
    {
      config,
      cfg,
      ...
    }:
    {

      sops.secrets."cache/private" = {
        sopsFile = ../../secrets/cache.yaml;
      };

      services.harmonia.cache = {
        enable = true;
        settings = {
          bind = "0.0.0.0:${toString cfg.port}";
          enable_compression = true;

        };
        signKeyPaths = [ config.sops.secrets."cache/private".path ];
      };

    };
}
