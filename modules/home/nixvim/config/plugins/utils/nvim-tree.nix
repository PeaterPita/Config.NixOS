{

  ################################################################################
  #                           Very handy documentation                           #
  # https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt #
  ################################################################################

  extraConfigLua = ''
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  '';
  plugins.nvim-tree = {

    enable = true;
    openOnSetup = true;
    settings = {
      # Adding auto-resize causes a pause on nvim entry. Requiring a enter to continue.
      # view = {
      #   auto_resize = true;
      # };
    };

  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ft";
      action = "<cmd>NvimTreeToggle<cr>";
    }
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>NvimTreeFindFile<cr>";
    }
  ];

}
