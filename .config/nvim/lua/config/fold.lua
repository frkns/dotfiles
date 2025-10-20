-- Custom folding configuration

function _G.custom_fold_text()
    local line = vim.fn.getline(vim.v.foldstart + 1)  -- get the next line after the fold header
    local count = vim.v.foldend - vim.v.foldstart + 1
    local preview = line:gsub("^%s+", ""):sub(1, 40)  -- trim leading spaces, limit length
    return string.format("🐬 %s ... (%d lines)", preview, count)
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
