return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {

        -- Main LSP Configuration`
        "neovim/nvim-lspconfig",
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim",    opts = {} },
            "saghen/blink.cmp",
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                    -- to define small helper and utility functions so you don't have to repeat yourself.
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)

                    ---@param client vim.lsp.Client
                    ---@param method vim.lsp.protocol.Method
                    ---@param bufnr? integer some lsp support methods only in specific files
                    ---@return boolean

                    local function client_supports_method(client, method, bufnr)
                        if vim.fn.has("nvim-0.11") == 1 then
                            return client:supports_method(method, bufnr)
                        else
                            return client.supports_method(method, { bufnr = bufnr })
                        end
                    end

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    -- See \:help CursorHold` for information about when this is executed`
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client_supports_method(
                            client,
                            vim.lsp.protocol.Methods.textDocument_documentHighlight,
                            event.buf
                        )
                    then
                        local highlight_augroup =

                            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {

                            buffer = event.buf,

                            group = highlight_augroup,

                            callback = vim.lsp.buf.document_highlight,

                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {

                            buffer = event.buf,

                            group = highlight_augroup,

                            callback = vim.lsp.buf.clear_references,

                        })

                        vim.api.nvim_create_autocmd("LspDetach", {

                            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),

                            callback = function(event2)
                                vim.lsp.buf.clear_references()

                                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                            end,

                        })
                    end
                end,

            })



            -- Diagnostics configuration

            vim.diagnostic.config({

                severity_sort = true,

                float = { border = "rounded", source = "if_many" },

                underline = { severity = vim.diagnostic.severity.ERROR },

                signs = vim.g.have_nerd_font and {

                    text = {

                        [vim.diagnostic.severity.ERROR] = "󰅚 ",

                        [vim.diagnostic.severity.WARN] = "󰀪 ",

                        [vim.diagnostic.severity.INFO] = "󰋽 ",

                        [vim.diagnostic.severity.HINT] = "󰌶 ",

                    },

                } or {},

                virtual_text = {

                    source = "if_many",

                    spacing = 2,

                    format = function(diagnostic)
                        local diagnostic_message = {

                            [vim.diagnostic.severity.ERROR] = diagnostic.message,

                            [vim.diagnostic.severity.WARN] = diagnostic.message,

                            [vim.diagnostic.severity.INFO] = diagnostic.message,

                            [vim.diagnostic.severity.HINT] = diagnostic.message,

                        }

                        return diagnostic_message[diagnostic.severity]
                    end,

                },

            })



            -- local original_capabilities = vim.lsp.protocol.make_client_capabilities()

            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- Define the LSP servers and their settings
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },

                bashls = {},
                docker_compose_language_service = {},
                dockerls = {},
                graphql = {},
                jsonls = {},
                marksman = {},
                ruff = {
                    init_options = {
                        settings = {
                            configurationPreference = "editorFirst",
                            lineLength = 100,
                            lint = {
                                select = { "ALL" },
                                preview = true,
                            },
                        },
                    },
                },
                sqlls = {},

                taplo = {},

                terraformls = {},

                yamlls = {},

            }



            -- Ensure linter & formatter tools are installed

            local ensure_installed = vim.tbl_keys(servers or {})

            vim.list_extend(ensure_installed, {

                "beautysh",

                "hadolint",

                "jsonlint",

                "mypy",

                "prettier",

                "pyproject-fmt",

                "ruff",

                "selene",

                "shellcheck",

                "sqlfluff",

                "sqlfmt",

                "stylua",

                "tflint",

                "yamllint",

            })



            require("mason-tool-installer").setup({

                ensure_installed = ensure_installed,

            })



            -- Setup LSP servers via mason-lspconfig

            require("mason-lspconfig").setup({

                ensure_installed = vim.tbl_keys(servers or {}),

                automatic_enable = true,

                handlers = {

                    function(server_name)
                        local server = servers[server_name] or {}

                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

                        require("lspconfig")[server_name].setup(server)
                    end,

                },

            })
        end,

    },

}
