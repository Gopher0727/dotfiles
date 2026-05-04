vim.pack.add({
	{ src = "https://github.com/nguyenvukhang/nvim-toggler" },
})

require("nvim-toggler").setup({
	inverses = {

	},
})

vim.keymap.set({ "n", "v" }, "<leader>cl", require("nvim-toggler").toggle)
