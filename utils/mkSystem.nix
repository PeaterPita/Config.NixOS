{
  inputs,
}:

hostname: users: system:

let
  lib = inputs.nixpkgs.lib;

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
        inputs.nixvim.homeModules.nixvim

      ]
      ++ filesFromDirRec ../modules/home # # TODO: Filter for only defaults and <user>.nix
    )
  );

  systemUsers = lib.genAttrs users (user: {
    isNormalUser = true;
    description = "${user} (mkUser)";
    extraGroups = [
      "wheel"
      "power"
      "wireshark"
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

    { nixpkgs.overlays = [ (final: prev: { myTestAttr = 5; }) ]; }

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
    # inputs.nixvim.homeModules.nixvim
  ]
  ++ filesFromDirRec ../modules/system;
}
