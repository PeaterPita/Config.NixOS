{
  plugins.trouble = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Trouble diagnostics toggle<cr>";
    }

  ];

}
