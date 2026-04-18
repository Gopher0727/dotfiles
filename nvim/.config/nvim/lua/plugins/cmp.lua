vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
})

require("blink.cmp").setup({
	keymap = {
		["<CR>"] = { "select_and_accept", "fallback" },
	},
	fuzzy = {
		implementation = "lua",
	},
})

