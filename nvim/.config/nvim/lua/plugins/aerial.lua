vim.pack.add({
	{ src = "https://github.com/stevearc/aerial.nvim" },
})

require("aerial").setup({
	backends = { "treesitter", "lsp", "markdown", "man" },
	layout = {
		-- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		-- min_width and max_width can be a list of mixed types.
		-- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
		width = nil,
		max_width = { 40, 0.3 },
		min_width = { 40, 0.2 },
	},
	filter_kind = false,
})

vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
