{
  lib,
  inputs,
}:

hostname: users:

let

  filesFromDirRec =
    dir: builtins.filter (path: lib.hasSuffix ".nix" path) (lib.filesystem.listFilesRecursive dir);

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
        ../users/${user}/${hostname}.nix # Per host user config. Only applies to that user on that host.

      ]
      ++ filesFromDirRec ../modules/home # # TODO: Filter for only defaults and <user>.nix
    )
  );

  systemUsers = lib.genAttrs users (user: {
    isNormalUser = true;
    description = "${user} (mkUser) (RW)";
    extraGroups = [
      "wheel"
      "power"
      "networkManager"
      "libvirtd"
    ];
  }

  );

in
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs lib; };

  modules = [

    { networking.hostName = hostname; }
    { users.users = systemUsers; }
    { nixpkgs.config.allowUnfree = true; }
    {
      nixpkgs.config.pipewire = {
        withLibcamera = false;
        withLibBluetooth = true;
      };
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
  ++ filesFromDirRec ../modules/system;
}
