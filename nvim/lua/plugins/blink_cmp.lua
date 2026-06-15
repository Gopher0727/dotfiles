vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
})

require("supermaven-nvim").setup({
	disable_inline_completion = false,
	keymaps = {
		accept_suggestion = nil,
		clear_suggestion = nil,
		accept_word = nil,
	},
})

require("blink.cmp").setup({
	completion = {
		menu = { auto_show = false },
	},
	keymap = {
		preset = "enter",
		["<Tab>"] = {
			function()
				local ok, suggestion = pcall(require, "supermaven-nvim.completion_preview")
				if ok and suggestion.has_suggestion() then
					vim.schedule(function()
						suggestion.on_accept_suggestion()
					end)
					return true
				end
			end,
			"show",
			"select_next",
			"fallback",
		},
	},
	sources = {
		default = { "lsp", "path", "snippets" },
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
