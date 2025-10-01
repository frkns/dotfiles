-- Key mappings

vim.keymap.set("v", ";", function()
    local mode       = vim.fn.mode()            -- current mode, "v" or "V"
    local start_line = vim.fn.line("v")
    local end_line   = vim.fn.line(".")


    -- Get comment marker (line comments only)
    local marker = (vim.bo.commentstring:match("^(.*)%%s") or vim.bo.commentstring):gsub("%s*$", "")

    -- Insert lines
    vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, false, { marker .. " ---===" })
    vim.api.nvim_buf_set_lines(0, end_line + 1, end_line + 1, false, { marker .. " ===---" })

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>zM", true, false, true), "n", true)
end, { desc = "Wrap visual selection in comment fold" })







-- General key mappings
vim.keymap.set('n', ',r', ':w<CR>:RunFile<CR>', { noremap = true, silent = false })
vim.keymap.set('n', ',c', ':%y+<CR>', { noremap = true, silent = false })
vim.api.nvim_set_keymap("n", "<C-y>", ":Themery<CR>", { noremap = true, silent = true, desc = "Switch Themes" })

-- Copy selection to clipboard
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })

-- Mouse selection to copy to clipboard
vim.api.nvim_set_keymap('v', '<LeftRelease>', '"+y', { noremap = true, silent = true })

-- Escape mapping
vim.keymap.set('i', 'jj', '<Esc>')

-- Leader key mappings
vim.keymap.set('n', '<leader>s', ':w<CR>:qa!<CR>', { desc = 'Save and Quit All' })
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
vim.keymap.set('n', '<leader>v', function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format file" })
vim.keymap.set('n', '<leader>l', vim.diagnostic.open_float, { desc = "Open LSP diagnostics" })
vim.keymap.set("n", "<leader>md", ":MarkdownPreview<CR>", { desc = "Markdown Preview" })

-- Telescope mappings
vim.keymap.set('n', '<Space>ff', ':Telescope find_files<CR>', { desc = 'fzf' })
vim.keymap.set('n', '<Space>fg', ':Telescope live_grep<CR>', { desc = 'grep' })
vim.keymap.set('n', '<Space>rg', ':Telescope live_grep<CR>', { desc = 'grep' })

-- LSP navigation
vim.keymap.set('n', 'gd', "<cmd>Telescope lsp_definitions<CR>", { noremap = true, silent = true })

-- Codeium toggle
_G.codeium_enabled = false
vim.cmd("CodeiumDisable")
function _G.toggle_codeium()
    if _G.codeium_enabled then
        vim.cmd("CodeiumDisable")
        _G.codeium_enabled = false
        print("Codeium disabled")
    else
        vim.cmd("CodeiumEnable")
        _G.codeium_enabled = true
        print("Codeium enabled")
    end
end

vim.keymap.set("n", ",d", _G.toggle_codeium, { noremap = true, silent = true })

-- -- Custom :X command
-- vim.api.nvim_create_user_command("X", function()
--     -- Your custom logic here
--     print("Intercepted :X command")
--     vim.cmd('wa')  -- Write all
--     vim.cmd('qa!') -- Quit all
-- end, {})
