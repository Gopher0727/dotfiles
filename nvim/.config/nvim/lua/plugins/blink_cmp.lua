vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
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
						"/Users/gopher/dotfiles/nvim/.config/nvim/lua/snippets/",
					},
				},
			},
		},
	},
	fuzzy = {
		implementation = "lua",
	},
})
