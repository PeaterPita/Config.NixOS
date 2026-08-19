{
  plugins = {
    lazydev.enable = true;

    otter = {
      enable = true;
      settings.handle_leading_whitespace = true;
    };

    plugins.none-ls = {
      enable = true;
      sources = {
        diagnostics.statix.enable = true;
        code_actions.statix.enable = true;
        diagnostics.deadnix.enable = true;
      };
    };

    friendly-snippets.enable = true;
    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
        region_check_events = "CursorMoved, CursorMovedI";
        delete_check_events = "TextChanged, InsertLeave";
      };
    };

    neogit = {
      enable = true;
      settings = {
        graph_style = "unicode";
        kind = "floating";
        log_view.kind = "floating";
      };
    };

    render-markdown = {
      enable = true;
      settings = {
        anti_conceal.enabled = true;
        completions.lsp.enabled = true;
      };
    };

    # Misc
    wakatime.enable = true;
    fidget.enable = true;
    undotree.enable = true;
    trouble.enable = true;
    colorizer.enable = true;

  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>u";
      action = "<cmd>UndotreeToggle<cr>";
      options = {
        silent = true;
        desc = "Undotree toggle";
      };
    }

    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Trouble diagnostics toggle<cr>";
    }

    {
      key = "<leader>gs";
      action = "<cmd>Neogit<CR>";
      options = {
        desc = "Git manager";
      };
    }

  ];
}
