{
  config,
  pkgs,
  lib,
  inputs,
  osConfig,
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
  noctaliaEnabled = config.modules.noctalia.enable;

  noctaliaTheme = ./config/plugins/noctalia.nix;
in
{
  options = {
    modules.nixvim.enable = lib.mkEnableOption "nixvim";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      nixfmt
      fd
    ];

    programs.ripgrep.enable = true;

    programs.nixvim = {
      _module.args = { inherit inputs osConfig; };

      imports =
        (builtins.filter (path: lib.hasSuffix ".nix" path && baseNameOf path != "noctalia.nix") (
          lib.filesystem.listFilesRecursive ./config
        ))
        ++ lib.optional noctaliaEnabled noctaliaTheme;

      colorschemes.catppuccin.enable = !noctaliaEnabled;

      enable = true;
      vimAlias = true;

      performance.combinePlugins.enable = true;
      diagnostic.settings = {
        virtual_text = true;
        signs = true;
        update_in_insert = false;
        underline = true;
      };
    };
  };
}
