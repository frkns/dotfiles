-- Custom folding configuration

function _G.custom_fold_text()
    local line = vim.fn.getline(vim.v.foldstart + 1)
    local count = vim.v.foldend - vim.v.foldstart + 1
    local preview = line:gsub("^%s+", ""):sub(1, 40)
    return string.format("🐬 %s ... (%d lines)", preview, count)
end

vim.opt.foldtext = 'v:lua.custom_fold_text()'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.GetCustomFoldLevel(v:lnum)'
vim.opt.fillchars = { fold = ' ' }

local fold_cache = {}  -- keyed by bufnr -> { changedtick, levels }

local function get_levels(bufnr)
    local tick = vim.api.nvim_buf_get_changedtick(bufnr)
    local cached = fold_cache[bufnr]
    if cached and cached.tick == tick then
        return cached.levels
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local levels = {}
    local depth = 0

    for i, line in ipairs(lines) do
        if line:match('%-%-%-%=%=%=') then
            depth = depth + 1
            levels[i] = '>' .. depth
        elseif line:match('%=%=%=%-%-%-') then
            levels[i] = '<' .. depth
            depth = math.max(0, depth - 1)
        else
            levels[i] = tostring(depth)
        end
    end

    fold_cache[bufnr] = { tick = tick, levels = levels }
    return levels
end

function _G.GetCustomFoldLevel(lnum)
    local bufnr = vim.api.nvim_get_current_buf()
    return get_levels(bufnr)[lnum] or '0'
end
