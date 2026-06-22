vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})

require("snacks").setup({
	indent = { enabled = true },
	scope = { enabled = true },
	input = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	bigfile = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = true },

	-- image = { enabled = true },
	-- animate = { enabled = true },
	-- picker = {
	-- 	enabled = true,
	-- 	prompt = " ",
	-- 	icons = {
	-- 		ui = { selected = " " },
	-- 	},
	-- 	layout = {
	-- 		preset = "telescope",
	-- 		layout = {
	-- 			row = 0.05,
	-- 			height = 0.85,
	-- 		},
	-- 	},
	-- 	win = {
	-- 		input = {
	-- 			keys = {
	-- 				["<Esc>"] = { "close", mode = { "n", "i" } },
	-- 			},
	-- 		},
	-- 		list = { wo = { wrap = false } },
	-- 		preview = { wo = { wrap = false } },
	-- 	},
	-- },
})
