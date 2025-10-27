{

  outputs =
    { nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib;

      mkSystem = import ./utils/mkSystem.nix {
        inherit
          lib
          inputs
          ;
      };
    in
    {
      nixosConfigurations = {
        laptop = mkSystem "Icarus" [ "peaterpita" ];
        desktop = mkSystem "Atlas" [ "peaterpita" ];
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

  };
}
