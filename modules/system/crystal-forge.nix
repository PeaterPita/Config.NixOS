{

  ######################################################################################################################
  #                                                 Based heavily on:                                                  #
  #                            offical docs: https://gitlab.com/crystal-forge/crystal-forge                            #
  # Sample dots: https://gitlab.com/usmcamp0811/dotfiles/-/blob/nixos/modules/nixos/services/crystal-forge/default.nix #
  ######################################################################################################################

  services.crystal-forge = {
    enable = false;

    database = {
      host = "localhost";
      user = "crystal_forge";
      name = "crystal_forge";
    };

    server = {
      enable = true;
      host = "127.0.0.1";
      port = 2929;

    };
    #
    # build = {
    #   enable = true;
    #   max_jobs = 6;
    #
    # };
    #

    # flakes.watched = [
    #   {
    #     name = "infrastructure";
    #     repo_url = "https://github.com/Misterio77/nix-starter-configs";
    #     auto_poll = false;
    #   }
    # ];

    # environments = [
    #   {
    #     name = "infrastructure";
    #     description = "testing";
    #     is_active = true;
    #     risk_profile = "LOW";
    #     compliance_level = "NONE";
    #
    #   }
    #
    # ];

    systems = [
      {
        hostname = "nixos";
        public_key = "kka3TPJ+nI5VQinIpw+kkZielOLPYikGVbcz/E2HTYc=";
        deployment_policy = "manual";
        environment = "dev";
        # flake_name = "infrastructure";
      }
    ];
  };
}
