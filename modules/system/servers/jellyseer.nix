(import ../../../utils/mkService.nix) {
  name = "seerr";
  port = 5055;

  routing = {
    protected = false;
    healthPath = "/api/v1/settings/public";
  };

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
