{
  lib,
  pkgs,
  ...
}:
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

      ########
      # Rust #
      ########
      rust_analyzer = {
        enable = true;
        config.settings."rust-analyzer" = {
          check.command = "clippy";
        };
      };

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
      ruff.enable = true;

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
      astro = {
        enable = true;
        config = {
          cmd = [
            "${pkgs.coreutils}/bin/env"

            ## Should dynamically fetch prettier from the astro package but this works for now. Version bumps will break.
            "NODE_PATH=${pkgs.typescript}/lib/node_modules:${pkgs.astro-language-server}/lib/node_modules/astro-language-server/node_modules/.pnpm/prettier@3.8.2/node_modules:${pkgs.astro-language-server}/lib/node_modules/astro-language-server/node_modules/.pnpm/prettier-plugin-astro@0.14.1/node_modules"

            "astro-ls"
            "--stdio"
          ];
          init_options.typescript.tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
        };
      };

      ########
      # Misc #
      ########
      yamlls.enable = true;
      tombi.enable = true;
      marksman.enable = true;
      sqruff.enable = true;
      kotlin_language_server.enable = true;

      lua_ls =
        let
          cc-defs = pkgs.fetchFromGitHub {
            owner = "nvim-computercraft";
            repo = "lua-ls-cc-tweaked";
            rev = "main";
            hash = "sha256-tEePK0ilz57oiW0nsnUDB/hbcJqTYrY1FzQhfnc9694=";
          };
        in
        {
          enable = true;
          config = {
            settings.Lua = {
              workspace.library = [
                "${cc-defs}/library"
              ];
              diagnostics.globals = [
                "vim"
                "turtle"
                "peripheral"
                "rednet"
                "fs"
                "os"
              ];
            };
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
        key = "<leader>rn";
        lspBufAction = "rename";
      }

      {
        key = "K";
        lspBufAction = "hover";
      }

      {
        key = "<leader>ca";
        lspBufAction = "code_action";

      }

      {
        key = "<leader>ih";
        action = lib.nixvim.mkRaw "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end";
      }
    ];
  };

}
