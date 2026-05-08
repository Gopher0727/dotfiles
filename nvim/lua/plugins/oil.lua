vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})

require("oil").setup({})

vim.keymap.set("n", "<leader>o", "<cmd>Oil<CR>", { desc = "Open Oil" })
