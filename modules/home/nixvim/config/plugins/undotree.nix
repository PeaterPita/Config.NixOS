{
  plugins.undotree = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>u";
      action = "vim.cmd.UndotreeToggle";
      options = {
        silent = true;
        desc = "Undotree toggle";
      };
    }

  ];

}
