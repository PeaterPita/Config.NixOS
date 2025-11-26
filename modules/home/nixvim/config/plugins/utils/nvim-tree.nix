{
  plugins.nvim-tree = {
    enable = true;
    openOnSetup = true;

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
