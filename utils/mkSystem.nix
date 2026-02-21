{
  inputs,
}:

hostname: users: system:

let
  lib = inputs.nixpkgs.lib;
  utils = import ../utils/utils.nix { inherit lib; };

  unstable-overlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  homeUsers = lib.genAttrs users (
    user:
    lib.mkMerge (
      [
        {
          home.username = user;
          home.homeDirectory = "/home/${user}";
          home.stateVersion = "25.05";
          home.enableNixpkgsReleaseCheck = false;
        }
        ../users/${user} # Default user config. Applies to all machines that  user is present on
        (utils.importIfExists ../users/${user}/${hostname}.nix) # Per host user config. Only applies to that user on that host.
        inputs.nixvim.homeModules.nixvim

      ]
      ++ builtins.filter (
        path:
        let
          bn = builtins.baseNameOf path;
        in
        bn == "default.nix" || bn == "${hostname}.nix"
      ) (utils.filesFromDirRec ../modules/home)
    )
  );

  systemUsers = lib.genAttrs users (user: {
    isNormalUser = true;
    description = "${user} (mkUser)";
    extraGroups = [
      "wheel"
      "wireshark"
      "power"
      "networkManager"
      "libvirtd"
    ];
  }

  );

in
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs lib; };
  modules = [
    { networking.hostName = hostname; }
    { users.users = systemUsers; }

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
      home-manager.users = homeUsers;
    }

    inputs.stylix.nixosModules.stylix
  ]
  ++ utils.filesFromDirRec ../modules/system;
}
