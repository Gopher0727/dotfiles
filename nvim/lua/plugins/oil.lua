vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})

require("oil").setup({
	default_file_explorer = false,
})

vim.keymap.set("n", "<leader>o", "<cmd>Oil<CR>", { desc = "Open Oil" })
