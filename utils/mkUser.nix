{
  inputs,
  lib,
  utils,
  hostname,
  user,
}:

{
  users.users.${user} = {
    isNormalUser = true;
    description = "${user} (mkUser)";
    extraGroups = [
      "wheel"
      "wireshark"
      "power"
      "networkManager"
      "libvirtd"
    ];
  };

  home-manager.users.${user} = lib.mkMerge (
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
  );
}
