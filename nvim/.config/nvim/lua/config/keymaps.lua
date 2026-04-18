-- quick fix
vim.keymap.set("n", "<leader>fix", vim.lsp.buf.code_action)

-- snippet edit
vim.keymap.set(
	"n",
	"<leader>se",
	function() require("scissors").editSnippet() end,
	{ desc = "Snippet: Edit" }
)

-- snippet add
vim.keymap.set(
	{ "n", "x" }, -- when used in visual mode, prefills the selection as snippet body
	"<leader>sa",
	function() require("scissors").addNewSnippet() end,
	{ desc = "Snippet: Add" }
)

