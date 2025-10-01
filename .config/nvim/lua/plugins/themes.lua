-- Theme-related plugins

return {
    -- Theme switcher
    {
        "zaldih/themery.nvim",
        lazy = false,
        config = function()
            require("themery").setup({
                themes = {
                    {
                        name = "Tokyo Night",
                        colorscheme = "tokyonight-night",
                        before = [[
                            vim.o.background = "dark"
                        ]],
                    },
                    {
                        name = "Moonlight",
                        colorscheme = "moonlight",
                        before = [[
                            vim.o.background = "dark"
                        ]],
                    },
                    {
                        name = "Solarized Light",
                        colorscheme = "solarized",
                        before = [[
                            vim.o.background = "light"
                        ]],
                    },
                    {
                        name = "Tokyo Day",
                        colorscheme = "tokyonight-day",
                        before = [[
                            vim.o.background = "light"
                        ]],
                    },
                    {
                        name = "Peachpuff",
                        colorscheme = "peachpuff",
                        before = [[]],
                    },
                },
            })
        end
    },
    
    
    -- Tokyo Night theme
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                transparent = true,
            })
        end,
    },
    
    -- PaperColor theme
    -- { 'pappasam/papercolor-theme-slim' },
    
    -- Solarized theme
    {
        'maxmx03/solarized.nvim',
        config = function()
            require('solarized').setup({
                variant = 'winter', -- "spring" | "summer" | "autumn" | "winter" (default)
                transparent = {
                    enabled = true, -- Master switch to enable transparency
                    pmenu = true,   -- Popup menu (e.g., autocomplete suggestions)
                    normal = true,  -- Main editor window background
                    neotree = true, -- Neo-tree file explorer
                    normalfloat = false, -- Floating windows
                    telescope = false,   -- Telescope fuzzy finder
                    lazy = false,        -- Lazy plugin manager UI
                    mason = false,       -- Mason manage external tooling
                },

                on_highlights = function(colors, color)
                    local darken = color.darken
                    local lighten = color.lighten
                    local blend = color.blend
                    local shade = color.shade
                    local tint = color.tint

                    ---@type solarized.highlights
                    local groups = {
                        Visual = { bg = colors.white, standout = true },
                        IncSearch = { fg = colors.mix_green, bg = colors.green },
                        Folded = { bg = colors.base3 },
                        DiagnosticError = { fg = colors.orange, bg = colors.mix_orange },
                        DiagnosticVirtualTextError = { fg = colors.orange, bg = colors.mix_orange },

                        -- Custom color scheme
                        LineNr = { fg = colors.base0 },
                        Identifier = { fg = colors.base01 },
                        Parameter = { fg = colors.base01 },
                        Property = { fg = colors.base01 },
                        Operator = { fg = colors.base01 },
                        Function = { fg = colors.cyan },
                        Keyword = { fg = colors.yellow },
                        Statement = { fg = colors.yellow },
                        Comment = { fg = colors.blue },
                        ["@comment.documentation"] = { fg = colors.blue },          -- Treesitter docstring highlighting
                        ["@string.documentation"] = { fg = colors.blue },           -- Some parsers use this
                        ["@lsp.type.comment.documentation"] = { fg = colors.blue }, -- LSP semantic tokens
                        Tag = { fg = colors.blue },
                        Constant = { fg = colors.red },
                        String = { fg = colors.red },
                        Type = { fg = colors.green },
                        Include = { fg = colors.magenta },
                    }

                    return groups
                end
            })
        end
    },
    
    -- Moonlight theme
    {
        'shaunsingh/moonlight.nvim',
    },

}
