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
      "<leader>pa" = {
        action = "find_files no_ignore=true hidden=true";
        options = {
          desc = "All Search";
        };
      };
      "<leader>ps" = {
        action = "live_grep";
        options = {
          desc = "Project Search";
        };
      };
      "<leader>gc".action = "git_commits";
      "<leader>gb".action = "git_branches";

    };

  };

}
