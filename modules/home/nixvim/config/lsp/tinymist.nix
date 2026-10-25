{ lib, ... }:
{
  lsp.servers.tinymist = {
    enable = true;
    config = {
      filetypes = [ "typst" ];
      settings = {
        exportPdf = "onType";
        lint = {
          enabled = true;
          when = "onType";
        };
        outputPath = "$root/build/$name";
      };
      on_attach = lib.nixvim.mkRaw ''
        function(client, bufnr)
            local name = vim.api.nvim_buf_get_name(bufnr)
            local main = vim.fs.find("main.typ", {
                upward = true,
                path = vim.fs.dirname(name)
            })[1]


            if main then 
                vim.g.typst_pinned = main
                client:exec_cmd({
                    title = "pin",
                    command = "tinymist.pinMain",
                    arguments = { main },
                }, {bufnr = bufnr})
            end 

            vim.api.nvim_create_user_command("OpenPdf", function()
                local root = main and vim.fs.dirname(main) or vim.fn.expand("%:p:h")
                local filename = main and "main" or vim.fn.expand("%:t:r")

                local ok, err = pcall(vim.ui.open, root .. "/build/" .. filename .. ".pdf")

                if not ok then
                    vim.notify("Failed to open PDF: " .. tostring(err), vim.log.levels.ERROR)
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

}
