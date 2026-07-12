vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
})

require("nvim-treesitter").setup({
	highlight = { enable = true },
	ensure_installed = { "go", "lua", "python", "rust", "c", "cpp" },
	install = {
		auto_install = true,
	},
})
