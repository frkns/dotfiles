-- Core vim options and settings

vim.g.cpp_compile_prefix = "g++ -std=c++23 -DLOCAL -O2 -g -Wall -Wextra -Wshadow -Wformat=2 -Wlogical-op -Wduplicated-cond -Wshift-overflow -fstack-protector-all -fsanitize=undefined -fsanitize-recover=all -Wno-unused-result -Wno-sign-conversion -Wno-sign-compare "
-- to precompile,
-- GOTO /usr/include/x86_64-linux-gnu/c++/11/bits,
-- RUN  g++ -x c++-header ... stdc++.h

-- Set leader key
vim.g.mapleader = " "
vim.g.python3_host_prog = '/usr/bin/python3.13'

-- vim.opts
vim.opt.scrolloff = 3
vim.opt.number = true
vim.opt.termguicolors = true
vim.o.cmdheight = 1
vim.opt.expandtab = true
vim.opt.shiftwidth = 0
vim.opt.tabstop = 4  -- trying sleuth
vim.opt.softtabstop = 0
vim.opt.ignorecase = true
vim.opt.mouse = 'a' -- Enable mouse support
vim.o.wrap = false

-- Edit past EOL
vim.opt.virtualedit = "all"

-- Remove auto-comments on carriage return and "o"
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ 'r', 'o' })
    end,
})

-- set C and C++ comment string
vim.cmd [[autocmd FileType c,cpp setlocal commentstring=//\ %s]]
vim.cmd [[autocmd FileType java setlocal commentstring=//\ %s]]

-- Diagnostic configuration
vim.diagnostic.config({
    severity_sort = true,
    virtual_text = {
        severity = { min = vim.diagnostic.severity.INFO },
    },
    signs = false,
    underline = {
        severity = { min = vim.diagnostic.severity.INFO },
    },
    update_in_insert = false,
})

-- Transparency
-- vim.cmd('highlight Normal guibg=NONE ctermbg=NONE')

-- Save current working directory on exit
vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        local cwd = vim.fn.getcwd()
        local file = io.open(os.getenv("HOME") .. "/.nvim_cwd", "w")
        if file then
            file:write(cwd)
            file:close()
        end
    end,
})
