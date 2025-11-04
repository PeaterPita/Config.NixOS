require("luasnip.loaders.from_vscode").lazy_load()


local cmp = require('cmp')
cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<tab>'] = cmp.mapping.confirm({ select = true }),
    }),


    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    }),
}


local myjdt = require('jdtls')
vim.keymap.set('n', '<leader>ji', myjdt.organize_imports)




local caps = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.enable('nixd')
vim.lsp.enable('luals')
vim.lsp.enable('jdtls')
vim.lsp.enable('html')
vim.lsp.enable('cssls')
vim.lsp.enable('jsonls')
vim.lsp.enable('clangd')


local nvim_lsp = require("lspconfig")
nvim_lsp.nixd.setup({
    settings = {
        nixd = {
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
})


vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function() vim.lsp.buf.format({ timeout_ms = 2000 }) end,
})



-- LSP Binds
local lsp_mappings = {
    { 'gd',         vim.lsp.buf.definition },    -- Go to definition
    { 'gr',         vim.lsp.buf.references },    -- Go to definition
    { 'gD',         vim.lsp.buf.declaration },   -- Go to declaration
    { 'k',          vim.lsp.buf.hover },         -- Hover Docs
    { '<leader>ca', vim.lsp.buf.code_action },   -- Code Actions
    { '<leader>e',  vim.diagnostic.open_float }, -- Code Actions
}

-- vim.lsp.on_attach(function(client, bufnr)
local opts = { remap = false, silent = true }
for i, map in pairs(lsp_mappings) do
    vim.keymap.set('n', map[1], function() map[2]() end, opts)
end
-- end)


vim.lsp.config['luals'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            }
        }
    }
}




local function setup_lsp_diags()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
            virtual_text = false,
            signs = true,
            update_in_insert = false,
            underline = true,
        }
    )
end
