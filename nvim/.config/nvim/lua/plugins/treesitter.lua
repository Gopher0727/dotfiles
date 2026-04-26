vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

require("nvim-treesitter").setup({
	install = {
		auto_install = true,
		sync = true,
	},
	install_dir = vim.fn.stdpath("data") .. "/site",
})
