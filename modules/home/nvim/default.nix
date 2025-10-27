{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.nvim;
in
{
  options = {
    modules.nvim.enable = lib.mkEnableOption "nvim";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nixd
      nixfmt-rfc-style
      lua-language-server
    ];

    home.file.".config/nvim/lua".source = ./lua;
    home.file.".config/nvim/after".source = ./after;

    programs.ripgrep.enable = true;
    programs.neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        telescope-nvim
        nvim-lspconfig

        catppuccin-nvim
        colorizer
        lualine-nvim

        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline

        nvim-jdtls

        fidget-nvim
        luasnip
        cmp_luasnip
        undotree
        vim-fugitive
      ];
      extraLuaConfig = ''
        require("PeaterPita")
      '';
    };
  };
}
