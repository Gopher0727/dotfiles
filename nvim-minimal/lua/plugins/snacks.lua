vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})

require("snacks").setup({
	indent = { enabled = true },
	scope = { enabled = true },
	input = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	bigfile = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = true },
})
