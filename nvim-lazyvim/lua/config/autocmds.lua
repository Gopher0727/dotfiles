-- treesitter start
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- edit 打开文件回到上次编辑位置
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local row = vim.fn.line([['"]])
        if row > 1 and row <= vim.fn.line("$") then
            vim.cmd("normal! g'\"")
        end
    end,
})

-- diagnostics hover
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, {
            focus = false,
            border = "rounded",
            source = "always",
        })
    end,
})

-- delete space end of line
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local ignore = {
            markdown = true,
            text = true,
            gitcommit = true,
        }

        if ignore[vim.bo.filetype] then
            return
        end

        local view = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- open terminal
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*toggleterm#*",
    callback = function()
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { buffer = 0, silent = true })
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { buffer = 0, silent = true })
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { buffer = 0, silent = true })
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { buffer = 0, silent = true })
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { buffer = 0, silent = true })
    end,
})
