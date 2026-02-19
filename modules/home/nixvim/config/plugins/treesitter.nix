{ pkgs, ... }:
{

  plugins.treesitter = {
    enable = true;
    grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    folding = true;
    nixvimInjections = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
  };
  plugins.treesitter-textobjects = {
    enable = true;
  };

}
