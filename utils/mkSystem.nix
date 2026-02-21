{
  inputs,
}:

hostname: users: system:

let
  lib = inputs.nixpkgs.lib;
  utils = import ../utils/utils.nix { inherit lib; };
  mkUser = import ../utils/mkUser.nix;

  unstable-overlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  userModules = map (
    user:
    mkUser {
      inherit
        inputs
        lib
        utils
        hostname
        user
        ;
    }
  ) users;

in
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs lib; };
  modules = [
    { networking.hostName = hostname; }
    # { users.users = systemUsers; }

    {
      nixpkgs.overlays = [
        (import ../pkgs/default.nix)
        unstable-overlay
      ];
    }

    ../hosts/common/common.nix
    ../hosts/${hostname}/hardware-configuration.nix
    ../hosts/${hostname}/configuration.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs; };

      home-manager.backupFileExtension = "backup";
    }

    inputs.stylix.nixosModules.stylix
  ]
  ++ userModules
  ++ utils.filesFromDirRec ../modules/system;
}
