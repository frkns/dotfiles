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



local function j2_comment_operator()
    local open          = "{# /* "
    local close         = " */ #}"
    local esc_open      = vim.pesc(open)
    local esc_close     = vim.pesc(close)

    local start_line    = vim.fn.getpos("'[")[2]
    local end_line      = vim.fn.getpos("']")[2]

    -- First pass: all non-blank lines commented? → uncomment; otherwise → comment all
    local all_commented = true
    for l = start_line, end_line do
        local line = vim.api.nvim_buf_get_lines(0, l - 1, l, false)[1]
        if line:match("%S") then
            local _, content = line:match("^(%s*)(.*)")
            if not (content:match("^" .. esc_open)
                    and content:match(esc_close .. "%s*$")) then
                all_commented = false
                break
            end
        end
    end

    for l = start_line, end_line do
        local line = vim.api.nvim_buf_get_lines(0, l - 1, l, false)[1]
        local indent, content = line:match("^(%s*)(.*)")

        if all_commented then
            content = content:gsub("^" .. esc_open, "")
            content = content:gsub(esc_close .. "%s*$", "")
            line = indent .. content
        else
            if content ~= ""
                and not (content:match("^" .. esc_open)
                    and content:match(esc_close .. "%s*$")) then
                line = indent .. open .. content .. close
            end
        end

        vim.api.nvim_buf_set_lines(0, l - 1, l, false, { line })
    end
end

_G.j2_comment_operator = j2_comment_operator

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*j2",
    callback = function()
        -- operator mapping (gc + motion)
        vim.keymap.set("n", "gc", function()
            vim.o.operatorfunc = "v:lua.j2_comment_operator"
            return "g@"
        end, { buffer = true, expr = true })

        -- gcc = comment current line properly
        vim.keymap.set("n", "gcc", function()
            vim.o.operatorfunc = "v:lua.j2_comment_operator"
            return "g@_"
        end, { buffer = true, expr = true })

        -- visual mode
        vim.keymap.set("x", "gc", function()
            vim.o.operatorfunc = "v:lua.j2_comment_operator"
            return "g@"
        end, { buffer = true, expr = true })
    end,
})
