-- LSP and completion plugins

local function get_uv_venv_python()
    -- Check for .venv in current directory (uv default)
    local venv_python = vim.fn.getcwd() .. '/.venv/bin/python'
    if vim.fn.filereadable(venv_python) == 1 then
        return venv_python
    end

    -- Fallback
    return 'python'
end

local function get_mypy_overrides()
    local venv_path = vim.fn.getcwd() .. '/.venv'
    if vim.fn.isdirectory(venv_path) == 1 then
        return { "--python-executable", venv_path .. "/bin/python", true }
    end
    return {}
end


return {
    -- Mason for LSP server management
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    -- LSP Configuration (pinned to commit before deprecation warnings)
    {
        'neovim/nvim-lspconfig',
        commit = 'f781e8e20ea9bcd9e2ebffb3fc0ac94b8d4c4954',
        dependencies = {
            'mason-org/mason.nvim',
            'mason-org/mason-lspconfig.nvim',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function()
            local lspconfig = require('lspconfig')

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

            local cmp = require('cmp')
            local luasnip = require('luasnip')

            -- Configure autocompletion
            cmp.setup({
                performance = {
                    debounce = 0, -- No debounce
                    throttle = 0, -- No throttling
                },
                completion = {
                    completeopt = "menu,menuone", -- Enable menu and auto-highlight the first item
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),

                    -- New: Ctrl-j / Ctrl-k to navigate items
                    ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                },
                sources = {
                    { name = 'buffer',   max_item_count = 3 },
                    { name = 'path',     max_item_count = 3 },
                    { name = 'nvim_lsp', max_item_count = 3 },
                    { name = 'luasnip',  max_item_count = 3 },
                },
            })

            -- Python LSP setup
            lspconfig.pylsp.setup({
                capabilities = capabilities,
                cmd = { get_uv_venv_python(), "-m", "pylsp" },
                on_attach = function(client, bufnr)
                    local python = get_uv_venv_python()
                    print("+ " .. python)
                end,
                settings = {
                    pylsp = {
                        plugins = {
                            pyflakes = { enabled = false }, -- for syntax errors
                            pycodestyle = { enabled = false },
                            mccabe = { enabled = false },
                            pylint = { enabled = false },
                            pylsp_mypy = {
                                enabled = true,
                                live_mode = true,
                                dmypy = false,
                                -- Point mypy to the venv's Python interpreter
                                pylsp_mypy = {
                                    enabled = true,
                                    live_mode = true,
                                    dmypy = false,
                                    overrides = get_mypy_overrides(), -- Call the function, don't pass it
                                },
                            },
                            pylsp_black = { enabled = true },
                            pylsp_isort = { enabled = false },
                            yapf = { enabled = false },
                        },
                    },
                },
            })

            -- hls
            lspconfig.hls.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    print("hls LSP attached")
                end,
                cmd = { "haskell-language-server-wrapper", "--lsp" },
                filetypes = { "haskell", "lhaskell", "cabal" },
                root_dir = lspconfig.util.root_pattern("hie.yaml", "stack.yaml", "cabal.project", "*.cabal", ".git"),
                settings = {
                    haskell = {
                        formattingProvider = "fourmolu", -- or "fourmolu"
                        cabalFormattingProvider = "cabalfmt",
                    },
                },
            })

            lspconfig.clangd.setup({
                cmd = {
                    "clangd",
                    "--header-insertion=never",
                    -- "--completion-style=detailed",
                },
                capabilities = capabilities, -- your existing capabilities
                on_attach = function(client, bufnr)
                    print("clangd LSP attached")
                end,
            })

            require("mason-lspconfig").setup({
                ensure_installed = { "pylsp", "clangd", "hls" },
                handlers = {
                    function(server_name)
                        -- Skip servers already configured above
                        if server_name == 'pylsp' or server_name == 'hls' or server_name == 'clangd' then
                            return
                        end
                        require('lspconfig')[server_name].setup({
                            capabilities = capabilities,
                            on_attach = function(client, bufnr)
                                print(server_name .. " LSP attached")
                            end,
                        })
                    end,
                },
            })
        end,
    },
}
