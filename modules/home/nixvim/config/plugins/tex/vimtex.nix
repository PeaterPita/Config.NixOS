{ pkgs, ... }:
{

  ####################################################################################
  #                          Super Helpful config example                            #
  # https://github.com/benbrastmckie/.config/blob/master/nvim/after/ftplugin/tex.lua #
  ####################################################################################

  keymaps = [
    {
      options.desc = "Display full details about word count";
      mode = "n";
      key = "<leader>lw";
      action = "<cmd>VimtexCountWords!<CR>";
    }
    {
      options.desc = "Run the compiler";
      mode = "n";
      key = "<leader>lc";
      action = "<cmd>VimtexCompile<CR>";
    }
    {
      options.desc = "Show the errors";
      mode = "n";
      key = "<leader>le";
      action = "<cmd>VimtexErrors<CR>";
    }
    {
      options.desc = "Open the PDF View (mostly incase no auto open)";
      mode = "n";
      key = "<leader>lv";
      action = "<cmd>VimtexView<CR>";
    }
    {
      options.desc = "Open table of contents";
      mode = "n";
      key = "<leader>lt";
      action = "<cmd>VimtexTocOpen<CR>";
    }
  ];
  plugins.vimtex = {
    enable = true;
    texlivePackage = pkgs.texliveFull.withPackages (ps: [ ps.collection-bibtexextra ]);
  };
  # plugins.typst-vim = {
  #   enable = true;
  # };

}
