{
  plugins.neogit = {
    enable = true;
    settings = {
      graph_style = "unicode";
      kind = "floating";

      log_view.kind = "floating";
    };
  };

  keymaps = [
    {
      key = "<leader>gs";
      action = "<cmd>Neogit<CR>";
      options = {
        desc = "Git manager";
      };
    }
  ];
}
