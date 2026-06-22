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


