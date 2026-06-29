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
vim.keymap.set("n", "<leader>ft", function()
	local theme_file = vim.fn.stdpath("data") .. "/selected_theme"
	local themes = vim.fn.getcompletion("", "color")
	require("telescope.pickers").new({}, {
		prompt_title = "Themes",
		finder = require("telescope.finders").new_table({ results = themes }),
		sorter = require("telescope.config").values.generic_sorter({}),
		previewer = require("telescope.previewers").new_buffer_previewer({
			define_preview = function(_, entry)
				vim.cmd.colorscheme(entry.value)
			end,
		}),
		attach_mappings = function(prompt_bufnr)
			local actions = require("telescope.actions")
			local state = require("telescope.actions.state")
			actions.select_default:replace(function()
				local selection = state.get_selected_entry()
				actions.close(prompt_bufnr)
				if selection then
					vim.cmd.colorscheme(selection.value)
					local f = io.open(theme_file, "w")
					if f then
						f:write(selection.value)
						f:close()
					end
				end
			end)
			return true
		end,
	}):find()
end, { desc = "Find theme" })
