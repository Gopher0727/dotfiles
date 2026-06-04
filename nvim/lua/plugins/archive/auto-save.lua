vim.pack.add({
	{ src = "https://github.com/pocco81/auto-save.nvim" },
})

require("auto-save").setup({
	enabled = true,
	trigger_events = { "InsertLeave", "TextChanged" },
	execution_message = {
		message = function()
			return "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S")
		end,
		dim = 0.18,
		cleaning_interval = 1250,
	},
	-- 条件过滤：不保存没有文件名的 buffer
	condition = function(buf)
		local fn = vim.fn
		if fn.getbufvar(buf, "&modifiable") == 1 and fn.getbufvar(buf, "&buftype") == "" and fn.expand("%:t") ~= "" then
			return true
		end
		return false
	end,
	write_all_buffers = false,
	debounce_delay = 135,
})

vim.keymap.set("n", "<leader>as", ":ASToggle<CR>", { desc = "Toggle AutoSave" })
