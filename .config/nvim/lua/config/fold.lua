-- Custom folding configuration

-- Define a Lua function that returns custom fold text
function _G.custom_fold_text()
    local count = vim.v.foldend - vim.v.foldstart + 1
    return '🐬 +---' .. ' ' .. count .. ' lines ------+'
end

-- Set foldtext to call your Lua function
vim.opt.foldtext = 'v:lua.custom_fold_text()'

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.GetCustomFoldLevel(v:lnum)'
vim.opt.fillchars = { fold = ' ' }

function _G.GetCustomFoldLevel(lnum)
    local current_line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ''
    if current_line:match('%-%-%-%=%=%=') then
        return '>1'
    end
    if current_line:match('%=%=%=%-%-%-') then
        return '<1'
    end

    return '='
end
