{
  outputs =

    ####################################################
    #                Possible outputs:                 #
    # https://wiki.nixos.org/wiki/Flakes#Output_schema #
    ####################################################
    { self, nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib;

      mkSystem = import ./utils/mkSystem.nix {
        inherit
          inputs
          ;
      };

      hostNames = builtins.filter (name: name != "common") (
        builtins.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./hosts))
      );

      nixosConfigurations = builtins.listToAttrs (
        map (hostname: {
          name = hostname;
          value =
            let
              meta = import ./hosts/${hostname}/host.nix;
            in
            mkSystem hostname meta.users meta.system;
        }) hostNames
      );

    in
    {
      inherit nixosConfigurations;

      checks."x86_64-linux" = builtins.mapAttrs (
        _: cfg: cfg.config.system.build.toplevel
      ) self.nixosConfigurations;

    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
