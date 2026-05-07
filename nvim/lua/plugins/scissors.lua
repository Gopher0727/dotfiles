vim.pack.add({
	{ src = "https://github.com/chrisgrieser/nvim-scissors" },
})

require("scissors").setup({
	snippetDir = "~/.config/nvim/lua/snippets/",
})

-- snippet edit
vim.keymap.set("n", "<leader>se", function()
	require("scissors").editSnippet()
end, { desc = "Snippet: Edit" })

-- snippet add
-- when used in visual mode, prefills the selection as snippet body
vim.keymap.set({ "n", "x" }, "<leader>sa", function()
	require("scissors").addNewSnippet()
end, { desc = "Snippet: Add" })
