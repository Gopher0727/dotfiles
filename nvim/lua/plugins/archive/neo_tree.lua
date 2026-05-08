vim.pack.add({
	{
		src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
		version = vim.version.range("3"),
	},
	-- dependencies
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	-- optional, but recommended
	"https://github.com/nvim-tree/nvim-web-devicons",
})

require("neo-tree").setup({
	window = {
		mappings = {
			["<CR>"] = function(state)
				local node = state.tree:get_node()
				local path = node.path
				if node.type == "directory" then
					require("neo-tree.sources.filesystem.commands").toggle_node(state)
					return
				end
				local target
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "neo-tree" then
						target = win
						break
					end
				end
				if target then
					vim.api.nvim_set_current_win(target)
				else
					vim.cmd("vsplit")
				end
				vim.cmd("e " .. vim.fn.fnameescape(path))
			end,
		},
	},
	filesystem = {
		hijack_netrw_behavior = "open_default",
	},
})

-- toggle sidebar
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { silent = true })
