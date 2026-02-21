{ lib, ... }:

{
  importIfExists = path: if builtins.pathExists path then path else { };

  filesFromDirRec =
    dir: builtins.filter (path: lib.hasSuffix ".nix" path) (lib.filesystem.listFilesRecursive dir);

}
