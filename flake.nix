{
  outputs =

    ####################################################
    #                Possible outputs:                 #
    # https://wiki.nixos.org/wiki/Flakes#Output_schema #
    ####################################################
    { self, nixpkgs, ... }@inputs:
    let
      mkSystem = import ./utils/mkSystem.nix {
        inherit
          inputs
          self
          ;
      };
    in
    {
      nixosConfigurations = {
        Atlas = mkSystem "Atlas" [ "peaterpita" ] "x86_64-linux";
        Icarus = mkSystem "Icarus" [ "peaterpita" ] "x86_64-linux";

        Olympus = mkSystem "Olympus" [ "peaterpita" ] "x86_64-linux";
        Hermes = mkSystem "Hermes" [ ] "x86_64-linux";
      };

      checks."x86_64-linux" = builtins.mapAttrs (
        _: cfg: cfg.config.system.build.toplevel
      ) self.nixosConfigurations;

    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ###########################################
    #   Neovim configuration system for nix   #
    # https://github.com/nix-community/nixvim #
    ###########################################
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astro-site = {
      url = "github:PeaterPita/astro-site";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ########################################
    #  MicroVM for lightweight NixOS VMs   #
    # https://github.com/astro/microvm.nix #
    ########################################
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
