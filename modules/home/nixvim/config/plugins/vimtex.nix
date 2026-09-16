{ pkgs, ... }:
{

  ####################################################################################
  #                          Super Helpful config example                            #
  # https://github.com/benbrastmckie/.config/blob/master/nvim/after/ftplugin/tex.lua #
  ####################################################################################

  keymaps = [
    {
      options.desc = "[L]atex [W]ord Count";
      mode = "n";
      key = "<leader>lw";
      action = "<cmd>VimtexCountWords!<CR>";
    }
    {
      options.desc = "[L]atex [C]ompile";
      mode = "n";
      key = "<leader>lc";
      action = "<cmd>VimtexCompile<CR>";
    }
    {
      options.desc = "[L]atex [E]rrors";
      mode = "n";
      key = "<leader>le";
      action = "<cmd>VimtexErrors<CR>";
    }
    {
      options.desc = "[L]atex [V]iew";
      mode = "n";
      key = "<leader>lv";
      action = "<cmd>VimtexView<CR>";
    }
    {
      options.desc = "[L]atex [T]oc";
      mode = "n";
      key = "<leader>lt";
      action = "<cmd>VimtexTocOpen<CR>";
    }
  ];
  plugins.vimtex = {
    enable = true;
    texlivePackage = pkgs.texliveFull.withPackages (ps: [ ps.collection-bibtexextra ]);
  };

}
