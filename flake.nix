{

  outputs =
    { nixpkgs, ... }@inputs:
    let

      mkSystem = import ./utils/mkSystem.nix {
        inherit
          inputs
          ;
      };

      devTemplates = import ./devshells;
    in
    {
      ####################################################
      #                Possible outputs:                 #
      # https://wiki.nixos.org/wiki/Flakes#Output_schema #
      ####################################################
      nixosConfigurations = {
        laptop = mkSystem "Icarus" [ "peaterpita" ] "x86_64-linux";
        desktop = mkSystem "Atlas" [ "peaterpita" ] "x86_64-linux";
      };

      templates = devTemplates;

    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ###########################################
    #   Neovim configuration system for nix   #
    # https://github.com/nix-community/nixvim #
    ###########################################
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ##################################################
    #     Compliance-First NixOS Fleet Management    #
    # https://gitlab.com/crystal-forge/crystal-forge #
    ##################################################
    # crystal-forge = {
    #   url = "gitlab:crystal-forge/crystal-forge";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #
    # };

  };
}
