vim.pack.add({
	{ src = "https://github.com/chrisgrieser/nvim-scissors" }
})

require("scissors").setup({
	snippetDir = "~/dotfiles/nvim/.config/nvim/lua/snippets/",
})
