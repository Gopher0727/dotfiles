vim.pack.add({
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
})

require("toggleterm").setup({
	open_mapping = { "<c-/>", "<c-_>" },
	persist_mode = false,
	direction = "horizontal",
	shade_terminals = false,
	highlights = { Normal = { guibg = "NONE" } },
	float_opts = {
		border = "curved",
		width = math.floor(vim.o.columns * 0.8),
		height = math.floor(vim.o.lines * 0.8),
	},
	size = function(term)
		if term.direction == "vertical" then
			return math.floor(vim.o.columns * 0.5)
		elseif term.direction == "horizontal" then
			return math.floor(vim.o.lines * 0.4)
		end
	end,
})

vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>")
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>")
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n><cmd>ToggleTerm<cr>")
