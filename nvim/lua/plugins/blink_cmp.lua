vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/saghen/blink.lib" },
})

require("blink.cmp").setup({
	completion = {
		menu = { auto_show = false },
	},
	keymap = {
		preset = "enter",
		["<Tab>"] = { "show", "select_next", "fallback" },
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
