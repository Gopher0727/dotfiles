-- lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.code_action)

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

-- toggle sidebar
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { silent = true })

-- terminal
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<cr>", { silent = true })
vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { silent = true })
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { silent = true })
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { silent = true })

-- move cursor
-- 行首（跳到第一个非空白字符）
vim.keymap.set({ "n", "v" }, "H", "^", { noremap = true, silent = true })
-- 行尾
vim.keymap.set({ "n", "v" }, "L", "$", { noremap = true, silent = true })

