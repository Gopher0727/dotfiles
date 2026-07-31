vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
})

require("supermaven-nvim").setup({
	disable_inline_completion = false,
	keymaps = {
		accept_suggestion = nil,
		clear_suggestion = "<C-e>",
		accept_word = nil,
	},
})

vim.keymap.set("n", "<leader>am", "<cmd>SupermavenToggle<cr>", { desc = "Toggle AI prediction" })

require("blink.cmp").setup({
	completion = {
		list = {
			selection = {
				preselect = false,
				auto_insert = false,
			},
		},
	},
	keymap = {
		preset = "none",
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Esc>"] = { "cancel", "fallback" },
	},
	sources = {
		default = { "lsp", "path" },
		min_keyword_length = 2,
	},
	fuzzy = {
		implementation = "lua",
	},
})
