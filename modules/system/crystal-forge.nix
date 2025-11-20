{

  ######################################################################################################################
  #                                                 Based heavily on:                                                  #
  #                            offical docs: https://gitlab.com/crystal-forge/crystal-forge                            #
  # Sample dots: https://gitlab.com/usmcamp0811/dotfiles/-/blob/nixos/modules/nixos/services/crystal-forge/default.nix #
  ######################################################################################################################

  services.crystal-forge = {
    enable = false;
    local-database = true;

    database = {
      host = "localhost";
      user = "crystal_forge3";
      name = "crystal_forge3";
      port = 5432;

    };

    dashboards = {
      enable = true;
      datasource = {
        host = "localhost";
        port = 5432;
        database = "crystal_forge3";
        user = "crystal_forge3";

      };

    };

    server = {
      enable = true;
      host = "0.0.0.0";
      port = 3000;
    };
  };

  # cache = {
  #   push_after_build = false;
  #   push_to = null;
  # };
  #
  # systems = [
  #   {
  #     hostname = "nixos";
  #     public_key = "kka3TPJ+nI5VQinIpw+kkZielOLPYikGVbcz/E2HTYc=";
  #     deployment_policy = "manual";
  #     environment = "dev";
  #   }
  # ];
  # };
}
