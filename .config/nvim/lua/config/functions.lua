-- Custom functions

-- Keep track of the terminal buffer
local term_buf = nil

function run_local()
    local file = vim.fn.expand('%:t') -- current file name
    local filetype = vim.bo.filetype  -- filetype
    local term_cmd = ""
    if filetype == "cpp" then
        term_cmd = string.format(
            "bash -c '%s %s 2>&1 && ./a.out < in 2>&1'",
            vim.g.cpp_compile_prefix, file
        )
        -- print("C++ execution completed.")
    elseif filetype == "python" then
        term_cmd = "python -u " .. file .. " < in"
        print("Python execution completed.")
    else
        print("Not a C++ or Python file!")
        return
    end
    -- If a previous terminal exists, delete it first
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        vim.api.nvim_buf_delete(term_buf, { force = true })
    end
    -- Open new terminal and store buffer id
    -- vim.cmd("belowright 12split | terminal " .. term_cmd)
    vim.cmd("terminal " .. term_cmd)
    term_buf = vim.api.nvim_get_current_buf()
end

function run_make()
    local make_cmd = "make"
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        vim.api.nvim_buf_delete(term_buf, { force = true })
    end
    vim.cmd("belowright 12split | terminal " .. make_cmd)
    term_buf = vim.api.nvim_get_current_buf()
    vim.cmd("startinsert")
end

-- Bind funcs
vim.api.nvim_set_keymap('n', ',t', ':w<CR>:lua run_local()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',m', ':w<CR>:lua run_make()<CR>', { noremap = true, silent = true })



-- Test current file with online-judge-tools (oj), reusing same compile flags
function run_oj()
    local file = vim.fn.expand('%:t')
    local filetype = vim.bo.filetype
    local cmd

    if filetype == 'cpp' then
        cmd = string.format(
            "oj t -c '" .. vim.g.cpp_compile_prefix .. "%s && ./a.out'",
            file
        )
    elseif filetype == 'python' then
        cmd = string.format("oj t -c 'python %s'", file)
    else
        print('oj: Unsupported filetype: ' .. filetype)
        return
    end

    vim.cmd('belowright 12split | terminal ' .. cmd)
    print('Tested with oj: ' .. cmd)
end

-- Key mappings for functions
vim.api.nvim_set_keymap('n', ',o', ':w<CR>:lua run_oj()<CR>', { noremap = true, silent = true })

-- LSP diagnostics handler removed to avoid conflicts with nvim-lspconfig migration
