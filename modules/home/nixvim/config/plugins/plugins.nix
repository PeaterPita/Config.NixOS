{
  plugins = {
    nvim-autopairs = {
      enable = true;
      settings = {
        disable_filetype = [
          "TelescopePrompt"
          "vim"
        ];
      };
    };

    luasnip = {
      enable = true;
      settings = {
        enbale_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
    };

    fidget = {
      enable = true;
    };

    undotree = {
      enable = true;
    };

    # typst-vim = {
    #   enable = true;
    # };

    image = {
      enable = true;
      settings = {
        backend = "kitty";
        integrations = {
          markdown = {
            enable = true;
            download_remote_images = true;
            filetypes = [ "markdown" ];
          };
        };
        window_overlap_Clear_ft_ignore = [
          "cmp_menu"
          "find_files"
        ];
      };
    };

    trouble.enable = true;
    colorizer.enable = true;

    neogit = {
      enable = true;
      settings = {
        graph_style = "unicode";
        kind = "floating";
        log_view.kind = "floating";
      };
    };

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
