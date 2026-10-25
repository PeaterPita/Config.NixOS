{
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}:
{
  plugins.lspconfig.enable = true;

  autoCmd = [
    {
      event = [ "BufWritePre" ];
      pattern = "*";
      command = "lua vim.lsp.buf.format({timeout_ms = 2000})";
    }

  ];
  lsp = {
    inlayHints.enable = true;
    servers = {

      #######
      # Nix #
      #######
      nixd = {
        enable = true;
        config.settings.nixd = {
          options =
            let
              flake = "${inputs.self}";
              host = osConfig.networking.hostName;
            in
            {
              nixos.expr = ''(builtins.getFlake "${flake}").nixosConfigurations.${host}.options'';
              home_manager.expr = ''(builtins.getFlake "${flake}").nixosConfigurations.${host}.options.home-manager.users.type.getSubOptions [ ]'';
            };
        };
      };

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

      #######
      # Web #
      #######
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
            "NODE_PATH=${pkgs.typescript}/lib/node_modules"
            "astro-ls"
            "--stdio"
          ];
          init_options.typescript.tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
        };
      };

      eslint = {
        enable = true;
        config.filetypes = [
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
          "astro"
        ];

      };

      ########
      # Misc #
      ########

      biome.enable = true;
      yamlls.enable = true;
      tombi.enable = true;
      marksman.enable = true;

      harper_ls = {
        enable = true;
        config.settings."harper-ls" = {
          linters.SpellCheck = false;
          dialect = "British";
        };
      };

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
