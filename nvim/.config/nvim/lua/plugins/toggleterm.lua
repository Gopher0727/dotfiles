vim.pack.add({
	"https://github.com/akinsho/toggleterm.nvim"
})

require("toggleterm").setup({
	open_mapping = [[<c-\>]],
	insert_mappings = true,
	terminal_mappings = true,
	start_in_insert = true,
	persist_mode = false,
	direction = "horizontal",
	shade_terminals = false,
	highlights = {
		Normal = { guibg = "NONE" },
		NormalFloat = { link = "Normal" },
		FloatBorder = { link = "Normal" },
	},
	hidden = true,

	-- 浮窗尺寸
	float_opts = {
		width = math.floor(vim.o.columns * 0.8),
		height = math.floor(vim.o.lines * 0.8),
	},
	-- 竖向/横向终端的尺寸
	size = function(term)
		if term.direction == "vertical" then
			return math.floor(vim.o.columns * 0.4)
		elseif term.direction == "horizontal" then
			return math.floor(vim.o.lines * 0.3)
		end
	end,
})
