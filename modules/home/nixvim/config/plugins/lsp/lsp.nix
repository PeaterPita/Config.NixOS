{ lib, ... }:
{
  plugins.lspconfig.enable = true;

  autoCmd = [
    {
      event = [ "BufWritePre" ];
      pattern = "*";
      callback = {
        __raw = "function() vim.lsp.buf.format({timeout_ms = 2000}) end";
      };
    }

  ];
  lsp = {
    inlayHints.enable = true;
    servers = {
      # "*" = { };

      ########
      # Java #
      ########
      jdtls = {
        enable = true;
        config = {

          keymaps = [
            {
              key = "<leader>ji";
              action = "require('jdtls').organize_imports";

            }

          ];
          root_markers = [
            "pom.xml"
            "gradle.build"
          ];

        };
      };
      ########
      # Rust #
      ########

      rust_analyzer.enable = true;

      #########
      # C/C++ #
      #########
      clangd = {
        enable = true;
        config = {
          cmd = [
            "clangd"
            "--background-index"
            "--clang-tidy"
            "--header-insertion=iwyu"
            "--completion-style=detailed"
            "--function-arg-placeholders"
            "--fallback-style=llvm"
          ];
        };
      };
      cmake.enable = true;

      ##########
      # Python #
      ##########
      basedpyright = {
        enable = true;
        config = {
          settings.basedpyright = {
            analysis = {
              autoSearchPaths = true;
              useLibraryCodeForTypes = true;
              typeCheckingMode = "recommended";
            };
          };
        };
      };
      ruff = {
        enable = true;
        config = {
          init_options = {
            settings = {
              lint.select = [
                "E"
                "W"
                "N"
                "DOC"
                "PL"
                "I"
                "UP"
                "F"
              ];
            };
          };
        };
      };

      gopls = {
        enable = true;
      };

      ##########
      # Web #
      ##########
      ts_ls.enable = true;
      svelte.enable = true;
      cssls.enable = true;
      html.enable = true;
      jsonls.enable = true;

      ########
      # Misc #
      ########
      yamlls.enable = true;
      tombi.enable = true;
      nixd.enable = true;
      lua_ls = {
        enable = true;
        config = {
          diagnostics.globals = [ "vim" ];
        };
      };
      qmlls = {
        enable = true;
        config = {
          cmd = [
            "qmlls"
            "-E"
          ];
        };
      };

    };

    keymaps = [

      {
        key = "gd";
        action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_definitions";
      }

      {
        key = "gr";
        lspBufAction = "references";
      }
      {
        key = "gD";
        lspBufAction = "declaration";

      }

      {
        key = "K";
        lspBufAction = "hover";

      }

      {
        key = "<leader>ca";
        lspBufAction = "code_action";

      }

      # {
      #   key = "<leader>e";
      #   action = lib.nixvim.mkRaw "function() vim.diagnostic.open_float() end";
      #
      # }

    ];
  };

}
