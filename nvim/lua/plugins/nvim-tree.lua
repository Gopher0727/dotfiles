vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
	-- dependencies
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
	filters = {
		dotfiles = false, -- 显示隐藏文件
		custom = { "^.git$" }, -- 隐藏 .git 目录
	},
	git = {
		enable = true,
		ignore = false, -- 显示 .gitignore 里的文件
	},
	renderer = {
		icons = {
			show = {
				file = true,
				folder = true,
				git = true,
			},
		},
		highlight_git = true,
	},
	-- 同步目录光标
	update_focused_file = {
		enable = true,
		update_root = false,
	},
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>fe", "<cmd>NvimTreeFindFile<CR>", { desc = "Find current file in tree" })
vim.keymap.set("n", "<leader>fl", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse tree" })
