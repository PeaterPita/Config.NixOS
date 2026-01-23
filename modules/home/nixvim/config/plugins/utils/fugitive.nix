{
  plugins.neogit = {
    enable = true;
    settings = {
      graph_style = "kitty";
      kind = "floating";

    };
  };

  keymaps = [
    {
      key = "<leader>gs";
      action = "<cmd>Neogit<CR>";
      options = {
        desc = "Find project files";
      };
    }
  ];
}
