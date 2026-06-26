{ pkgs, ... }:

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
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
    };

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
          typst.enabled = false;
        };
        window_overlap_clear_ft_ignore = [
          "cmp_menu"
          "find_files"
        ];
      };
    };

    wakatime.enable = true;

    fidget.enable = true;
    undotree.enable = true;
    trouble.enable = true;
    colorizer.enable = true;

    toggleterm = {
      enable = true;
      settings = {
        direction = "float";
        float_opts = {
          border = "curved";
          width = 120;
          height = 40;
        };

        open_mapping = "[[<A-f>]]";
        start_in_insert = true;
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

  };

  extraPackages = with pkgs; [ imagemagick ];
  extraLuaPackages = ps: [ ps.magick ];

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
