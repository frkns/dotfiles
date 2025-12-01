-- Utility plugins for editing, navigation, and productivity

return {
    -- Visual surround for wrapping text
    {
        "NStefan002/visual-surround.nvim",
        config = function()
            require("visual-surround").setup({
                -- your config
            })
        end,
    },

    -- Color picker and previews
    -- {
    --     "uga-rosa/ccc.nvim",
    --     config = function()
    --         require("ccc").setup({
    --             highlighter = {
    --                 auto_enable = true, -- Enable previews automatically
    --             },
    --         })
    --     end
    -- },
    --
    -- Mini icons
    {
        'echasnovski/mini.nvim',
        version = '*',
        config = function()
            require('mini.icons').setup()
        end,
    },

    -- Better comments
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
    },

    -- Treesitter for better syntax highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                indent = { enable = true },
                highlight = {
                    enable = true,
                },
            }
        end,
    },

    -- Code Runner plugin
    {
        'CRAG666/code_runner.nvim',
        config = function()
            require('code_runner').setup({
                filetype = {
                    lean = {
                        "cd $dir &&",
                        "lean --run $fileName",
                    },
                    asm = {
                        "cd $dir &&",
                        "nasm -f elf64 $fileName -o /tmp/$fileNameWithoutExt.o &&",
                        "ld /tmp/$fileNameWithoutExt.o -o /tmp/$fileNameWithoutExt &&",
                        "/tmp/$fileNameWithoutExt",
                        "&& /bin/rm /tmp/$fileNameWithoutExt /tmp/$fileNameWithoutExt.o"
                    },
                    java = {
                        "cd \"$dir\" &&",
                        "javac \"$fileName\"",
                    },
                    python = {
                        "cd $dir &&",
                        "python -u $fileName &&",
                        "if [ -f plot.png ]; then eog plot.png > /dev/null 2>&1; /bin/rm plot.png; fi"
                    },
                    cpp = {
                        "cd $dir &&",
                        vim.g.cpp_compile_prefix .. "$fileName -o a.out && ./a.out",
                        "&& /bin/rm a.out",
                    },
                    c = {
                        "cd $dir &&",
                        "gcc $fileName -o /tmp/$fileNameWithoutExt -fno-stack-protector &&",
                        "/tmp/$fileNameWithoutExt",
                        "&& /bin/rm /tmp/$fileNameWithoutExt",
                    },
                    r = {
                        "Rscript $fileName &&",
                        "if [ -f Rplots.pdf ]; then zathura Rplots.pdf; /bin/rm Rplots.pdf; fi"
                    },
                    haskell = {
                        "cd $dir &&",
                        "runghc $fileName"
                    },
                    rust = {
                        "cd $dir &&",
                        "rustc $fileName -o /tmp/rustout && /tmp/rustout &&",
                        "/bin/rm /tmp/rustout"
                    }
                },
            })
        end,
    },

    -- Auto-pairs
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },

    -- AI code completion
    {
        'Exafunction/windsurf.vim',
        config = function()
            vim.keymap.set('i', '<Tab>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
        end,
    },
    -- {
    --     'github/copilot.vim'
    -- },

    -- Git conflict resolution
    { 'akinsho/git-conflict.nvim', version = "*" },

    -- Tmux navigation
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },

    -- File explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        lazy = false,
        opts = {
            close_if_last_window = true,
            enable_git_status = false,
            default_component_configs = {
                symlink_target = {
                    enabled = true,
                },
            },
            filesystem = {
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_hidden = false,
                },
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                },
            },
            window = {
                mappings = {
                    ["l"] = "open",
                    ["h"] = "close_node",
                    ["<CR>"] = "open",
                    ["."] = function(state)
                        local node = state.tree:get_node()
                        local path = node.path
                        if node.type ~= "directory" then
                            path = vim.fn.fnamemodify(path, ":h")
                        end
                        vim.cmd("cd " .. vim.fn.fnameescape(path))
                        vim.notify("Changed Neovim CWD to: " .. path)
                    end,
                },
            },
        },
    },

    -- Markdown preview
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = { "markdown" },
        config = function()
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_browser = "firefox"
            vim.g.mkdp_markdown_css = ""
            vim.g.mkdp_preview_options = {
                disable_sync_scroll = 0,
                disable_filename = 0,
            }
        end
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            -- "rafamadriz/friendly-snippets",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            local ls = require("luasnip")
            local cmp = require("cmp")

            -- Basic LuaSnip setup
            ls.setup({
                history = true,
                region_check_events = "InsertEnter",
                delete_check_events = "TextChanged",
            })

            -- Load VSCode snippets (friendly-snippets)
            -- require("luasnip.loaders.from_vscode").lazy_load()

            require("luasnip.loaders.from_vscode").lazy_load({
                paths = "~/.config/nvim/snippets",
            })

            -- local keymap = vim.keymap.set
            --
            -- -- Tab: completion menu next, snippet expand/jump, or fallback
            -- keymap("i", "<Tab>", function()
            --     if cmp.visible() then
            --         return cmp.select_next_item()
            --     elseif ls.expand_or_jumpable() then
            --         return ls.expand_or_jump()
            --     else
            --         return "<Tab>"
            --     end
            -- end, { expr = true, silent = true })
            --
            -- -- Shift-Tab: completion menu prev, snippet jump backward, or fallback
            -- keymap("i", "<S-Tab>", function()
            --     if cmp.visible() then
            --         return cmp.select_prev_item()
            --     elseif ls.jumpable(-1) then
            --         return ls.jump(-1)
            --     else
            --         return "<S-Tab>"
            --     end
            -- end, { expr = true, silent = true })
            --
            -- -- Choice node cycling
            -- keymap("i", "<C-l>", function()
            --     if ls.choice_active() then
            --         ls.change_choice(1)
            --     end
            -- end, { silent = true })
        end,
    },



    -- Indentation detection
    { "tpope/vim-sleuth",          event = "BufReadPost" },
    {
        "akinsho/toggleterm.nvim",
        version = "*", -- always use latest stable
        config = function()
            require("toggleterm").setup {
                size = 10,
                open_mapping = [[<C-n>]], -- toggle with <Space><Enter>
                direction = "horizontal",
                shade_terminals = false,
                shading_factor = 2,
                start_in_insert = true,
                insert_mappings = true,
                terminal_mappings = true,
            }

            -- Optional: better terminal keymaps
            function _G.set_terminal_keymaps()
                local opts = { buffer = 0 }
                vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
            end

            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        end
    },



}
