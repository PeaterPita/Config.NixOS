{
  outputs =

    ####################################################
    #                Possible outputs:                 #
    # https://wiki.nixos.org/wiki/Flakes#Output_schema #
    ####################################################
    { nixpkgs, ... }@inputs:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";

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
        server = mkSystem "Olympus" [ "peaterpita" ] "x86_64-linux";
        ingress = mkSystem "Hermes" [ "peaterpita" ] "x86_64-linux";

      };

      templates = import ./devshells;

      devShells."x86_64-linux".default = pkgs.mkShell {
        packages = with pkgs; [
          sops
          age
          openssl
        ];
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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
  };
}
