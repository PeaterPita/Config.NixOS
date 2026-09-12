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
in
{
  options = {
    modules.nixvim.enable = lib.mkEnableOption "nixvim";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      nixfmt
    ];

    modules.matugen = {
      templates."nvim" = {
        outputPath = "~/.config/nvim/lua/matugen_test.lua";
        reloadCmd = "pkill -SIGUSR1 nvim";
        text = ''
          require("base16-colorscheme").setup({
              base00 = "{{colors.background.default.hex}}",
              base01 = "{{colors.surface_container_lowest.default.hex}}",
              base02 = "{{colors.surface_container_low.default.hex}}",
              base03 = "{{colors.outline_variant.default.hex}}",
              base04 = "{{colors.on_surface_variant.default.hex}}",
              base05 = "{{colors.on_surface.default.hex}}",
              base06 = "{{colors.inverse_on_surface.default.hex}}",
              base07 = "{{colors.surface_bright.default.hex}}",
              base08 = "{{colors.tertiary.default.hex | lighten: -5}}",
              base09 = "{{colors.tertiary.default.hex}}",
              base0A = "{{colors.secondary.default.hex}}",
              base0B = "{{colors.primary.default.hex}}",
              base0C = "{{colors.tertiary.default.hex | lighten: 10}}",
              base0D = "{{colors.primary.default.hex | lighten: 15}}",
              base0E = "{{colors.secondary.default.hex | lighten: 10}}",
              base0F = "{{colors.error.default.hex}}",
          })
        '';
      };
    };

    programs.ripgrep.enable = true;

    programs.nixvim = {
      _module.args = { inherit inputs osConfig; };

      extraConfigLua = ''
        vim.opt.rtp:append("/home/peaterpita/Coding/testing.nvim")
      '';

      imports = builtins.filter (path: lib.hasSuffix ".nix" path) (
        lib.filesystem.listFilesRecursive ./config
      );

      enable = true;
      nixpkgs.source = pkgs.path;
      vimAlias = true;

      # performance.combinePlugins.enable = true;
      diagnostic.settings = {
        virtual_text = true;
        signs = true;
        update_in_insert = false;
        underline = true;
      };
    };
  };
}
