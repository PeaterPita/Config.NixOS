{

  outputs =
    { nixpkgs, ... }@inputs:
    let

      mkSystem = import ./utils/mkSystem.nix {
        inherit
          inputs
          ;
      };
    in
    {
      nixosConfigurations = {
        laptop = mkSystem "Icarus" [ "peaterpita" ] "x86_64-linux";
        desktop = mkSystem "Atlas" [ "peaterpita" ] "x86_64-linux";
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ##################################################
    #     Compliance-First NixOS Fleet Management    #
    # https://gitlab.com/crystal-forge/crystal-forge #
    ##################################################
    crystal-forge = {
      url = "gitlab:crystal-forge/crystal-forge";
      inputs.nixpkgs.follows = "nixpkgs";

    };

  };
}
