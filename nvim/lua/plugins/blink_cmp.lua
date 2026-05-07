vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/saghen/blink.lib" },
})

require("blink.cmp").setup({
	keymap = {
		["<CR>"] = { "select_and_accept", "fallback" },
	},
	sources = {
		providers = {
			snippets = {
				opts = {
					search_paths = {
						"~/.config/nvim/lua/snippets/",
					},
				},
				score_offset = 100,
			},
		},
	},
	fuzzy = {
		implementation = "lua",
	},
})
