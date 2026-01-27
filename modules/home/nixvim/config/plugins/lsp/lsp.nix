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
      nixd.enable = true;
      html.enable = true;
      lua_ls = {
        enable = true;
        config = {
          diagnostics.globals = [ "vim" ];
        };
      };
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
      cssls.enable = true;
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
      svelte.enable = true;
      basedpyright = {
        enable = true;
        config = {
          settings.basedpyright = {
            disableOrganizeImports = true;
            analysis = {
              ignore = [ "*" ];
              autoSearchPaths = true;
              useLibraryCodeForTypes = true;
              typeCheckingMode = "off";
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
                "PL"
                "I"
                "UP"
                "F"
              ];
            };
          };
        };
      };
      ts_ls.enable = true;

      jsonls.enable = true;

      yamlls.enable = true;
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
