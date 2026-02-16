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

    # {
    #   event = [
    #     "BufEnter"
    #     "BufWritePost"
    #     "InsertLeave"
    #   ];
    #   pattern = "*";
    #   callback.__raw = ''
    #     function() vim.lsp.codelens.refresh({bufnr = 0}) end
    #   '';
    # }
    #
  ];
  lsp = {
    inlayHints.enable = true;
    servers = {
      "*" = { };

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

      ########
      # Misc #
      ########
      yamlls.enable = true;
      tombi.enable = true;
      tinymist = {
        enable = true;
        config = {
          filetypes = [ "typst" ];
          settings = {
            exportPdf = "onType";
            formatterMode = "typstfmt";
            lint = {
              enabled = true;
              when = "onType";
            };
            outputPath = "$root/build/$dir/$name";
          };
          on_attach = lib.nixvim.mkRaw ''
            function(client, bufnr)

                vim.api.nvim_create_user_command("OpenPdf", function()
                    local filepath = vim.api.nvim_buf_get_name(0)
                    if filepath:match("%.typ$") then
                        local dir = vim.fn.expand("%:p:h")
                        local filename = vim.fn.expand("%:t:r")

                        local pdf = dir .. "/build/".. filename .. ".pdf"
                        vim.system({"xdg-open", pdf}) 
                    end 
                end, {})
                
                vim.keymap.set("n", "<leader>tp", function()
                    vim.g.typst_pinned = vim.fn.expand("%:t")
                    client:exec_cmd({
                    title = "pin",
                    command = "tinymist.pinMain",
                    arguments = { vim.api.nvim_buf_get_name(0) },
                    }, { bufnr = bufnr })
                    print("Pinned: " .. vim.g.typst_pinned)
                end, { desc = "[T]inymist [P]in", noremap = true })



                vim.keymap.set("n", "<leader>tu", function()
                    vim.g.typst_pinned = nil
                client:exec_cmd({
                title = "unpin",
                command = "tinymist.pinMain",
                arguments = { vim.v.null },
                }, { bufnr = bufnr })
                    end, { desc = "[T]inymist [U]npin", noremap = true })

            end
          '';
        };
      };
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

      # {
      #   key = "<leader>cr";
      #   action = lib.nixvim.mkRaw "vim.lsp.codelens.run";
      # }

      {
        key = "<leader>ca";
        lspBufAction = "code_action";

      }
    ];
  };

}
