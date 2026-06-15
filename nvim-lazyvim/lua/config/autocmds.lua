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
