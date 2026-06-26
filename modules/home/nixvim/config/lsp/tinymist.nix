{ lib, ... }:
{

  lsp.servers.tinymist = {
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
        outputPath = "$root/build/$name";
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

}
