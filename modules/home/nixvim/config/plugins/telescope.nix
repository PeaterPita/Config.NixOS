{
  plugins.web-devicons.enable = true;
  plugins.telescope = {
    enable = true;

    keymaps = {
      "<leader>pf" = {
        action = "find_files";
        options = {
          desc = "Find project files";
        };
      };
      "<leader>ps" = {
        action = "live_grep";
        options = {
          desc = "Project Search";
        };
      };

    };

  };

}
