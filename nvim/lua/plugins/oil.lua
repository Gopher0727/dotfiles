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

vim.keymap.set("n", "<leader>e", vim.cmd.Oil, { desc = "Open Oil" })
