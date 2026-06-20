vim.pack.add({
	{
		src = "https://github.com/kylechui/nvim-surround",
		version = vim.version.range("4.x"),
	},
})

vim.g.nvim_surround_no_normal_mappings = true
vim.g.nvim_surround_no_visual_mappings = true

require("nvim-surround").setup({})

vim.keymap.set("n", "sa", "<Plug>(nvim-surround-normal)", { desc = "Add surround (motion)" })
vim.keymap.set("n", "sd", "<Plug>(nvim-surround-delete)", { desc = "Delete surround" })
vim.keymap.set("n", "sr", "<Plug>(nvim-surround-change)", { desc = "Change surround" })
vim.keymap.set("x", "s", "<Plug>(nvim-surround-visual)", { desc = "Add surround (visual)" })
