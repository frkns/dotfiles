-- Autocmds for file type specific behavior and optimizations

-- File type specific mappings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    callback = function()
        vim.keymap.set("n", ",f",
            ":w<CR>:term " .. vim.g.cpp_compile_prefix .. "-o a.out % && ./a.out && rm ./a.out<CR>",
            { buffer = true, noremap = true, silent = true })
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.keymap.set("n", ",f", ":w<CR>:term bash -c 'cd %:p:h && python %:t'<CR>",
            { buffer = true, noremap = true, silent = true })
    end
})

-- Function to detect and optimize for large files
local function optimize_large_files()
    local max_file_size = 1024 * 1024 -- in bytes
    local file_size = vim.fn.getfsize(vim.fn.expand("%:p"))
    if file_size > max_file_size then
        vim.cmd("syntax off")
        vim.cmd("filetype off")
        vim.o.undofile = false
        vim.o.swapfile = false
        vim.g.loaded = true
        print("Large file detected: Optimizations applied")
    end
end

-- Run the optimization on BufRead and FileReadPost events
vim.api.nvim_create_autocmd({ "BufRead", "FileReadPost" }, {
    callback = optimize_large_files,
})

-- treesitter likes to override our fold settings so we'll override theirs
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.foldmethod = 'expr'
        vim.opt.foldexpr = 'v:lua.GetCustomFoldLevel(v:lnum)'
    end,
})
