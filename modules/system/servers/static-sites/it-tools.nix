(import ../../../../utils/mkService.nix) {
  name = "it-tools";
  port = 3006;
  domain = "tools";

  routing.protected = true;

  homepage = {
    group = "Apps";
    description = "Dev Utils";
  };

  extraConfig =
    {
      pkgs,
      cfg,
      vars,
      ...
    }:
    {

      homelab.services.authelia.rules = [
        {
          domain = [ "${cfg.domain}.${vars.baseDomain}" ];
          policy = "one_factor";
        }
      ];

      homelab.services.static-sites.packageSites.it-tools = {
        package = pkgs.it-tools;
        subfolder = "lib";
        port = cfg.port;
      };

    };

}
