vim.pack.add({
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
})

require("telescope").setup({
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "truncate" },
		mappings = {
			i = {
				["<esc>"] = require("telescope.actions").close,
			},
		},
	},
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Commands" })
