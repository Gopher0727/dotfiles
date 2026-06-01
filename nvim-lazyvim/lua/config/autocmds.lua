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

-- disable spell checking for markdown
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.wo.spell = false
    end,
})

-- auto-save
vim.g.auto_save_enabled = true

vim.api.nvim_create_user_command("ASToggle", function()
    vim.g.auto_save_enabled = not vim.g.auto_save_enabled
    vim.notify("Auto-save: " .. (vim.g.auto_save_enabled and "ON" or "OFF"))
end, {})

local autosave_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    group = autosave_group,
    pattern = "*",
    callback = function()
        if not vim.g.auto_save_enabled then
            return
        end
        local buf = vim.api.nvim_get_current_buf()
        if not vim.bo[buf].modifiable or vim.bo[buf].buftype ~= "" then
            return
        end
        local ignored = { TelescopePrompt = true, harpoon = true, NvimTree = true }
        if ignored[vim.bo[buf].filetype] then
            return
        end
        local name = vim.api.nvim_buf_get_name(buf)
        if name == "" or not vim.uv.fs_stat(name) then
            return
        end
        pcall(vim.cmd, "silent! write")
    end,
})

vim.keymap.set("n", "<leader>as", "<cmd>ASToggle<cr>", { desc = "Toggle auto-save" })
