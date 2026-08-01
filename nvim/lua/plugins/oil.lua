vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("oil").setup({
	columns = {
		"permissions",
		"size",
		"mtime",
		"icon",
	},
})

-- <leader>o 切换 Oil：打开 / 关闭回到原 buffer
vim.keymap.set("n", "<leader>o", function()
	if vim.bo.filetype == "oil" then
		require("oil").close()
	else
		require("oil").open()
	end
end, { desc = "Toggle Oil" })
