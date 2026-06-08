(import ../../../utils/mkService.nix) {
  name = "seerr";
  port = 5055;

  routing.protected = false;

  homepage = {
    group = "Apps";
    description = "Media Requests";
  };

  extraConfig =
    { cfg, ... }:
    {
      services.seerr = {
        enable = true;
        port = cfg.port;
      };
    };

}
