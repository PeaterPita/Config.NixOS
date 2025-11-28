{ lib, ... }:
{
  plugins.lspconfig.enable = true;
  plugins.lsp-lines.enable = true;

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
      "*" = { };
      nixd.enable = true;
      html.enable = true;
      lua_ls.enable = true;
      luals.enable = true;
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
      clangd.enable = true;
      svelte.enable = true;
      pyright.enable = true;

      jsonls.enable = true;

      yamlls.enable = true;

    };

    keymaps = [

      {
        key = "gd";
        lspBufAction = "definition";
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
        key = "k";
        lspBufAction = "hover";

      }

      {
        key = "<leader>ca";
        lspBufAction = "code_action";

      }

      {
        key = "<leader>e";
        action = lib.nixvim.mkRaw "function() vim.diagnostic.open_float() end";

      }

    ];
  };

}
