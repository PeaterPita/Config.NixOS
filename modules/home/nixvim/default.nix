{
  config,
  pkgs,
  lib,
  ...
}:
#########################################################################
#                            Super Helpful Doc Site                     #
#             https://nix-community.github.io/nixvim/index.html         #
#                             ++Example config                          #
# https://github.com/dc-tec/nixvim/blob/main/config/plugins/cmp/cmp.nix #
#########################################################################

let
  cfg = config.modules.nixvim;
in
{
  options = {
    modules.nixvim.enable = lib.mkEnableOption "nixvim";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];

    programs.ripgrep.enable = true;

    programs.nixvim = {
      imports = builtins.filter (path: lib.hasSuffix ".nix" path) (
        lib.filesystem.listFilesRecursive ./config
      );
      enable = true;
      vimAlias = true;
      diagnostic.settings = {
        virtual_text = true;
        signs = true;
        update_in_insert = true;
        underline = true;
      };
    };
  };
}
