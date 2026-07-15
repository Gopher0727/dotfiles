vim.pack.add({
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/saghen/blink.cmp" },
})

require("blink.cmp").setup({
	completion = {
		list = { selection = { preselect = false, auto_insert = false } },
		menu = { draw = { treesitter = { "lsp" } } },
		documentation = { auto_show = true },
	},
	sources = {
		default = { "lsp", "path", "buffer" },
	},
	keymap = {
		preset = "none",
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Esc>"] = { "cancel", "fallback" },
	},
})
