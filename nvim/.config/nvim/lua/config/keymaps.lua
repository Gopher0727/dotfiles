-- lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.code_action)

-- move cursor
vim.keymap.set({ "n", "v" }, "H", "^", { noremap = true, silent = true }) -- 行首（跳到第一个非空白字符）
vim.keymap.set({ "n", "v" }, "L", "$", { noremap = true, silent = true })

-- edit window
vim.keymap.set("n", "<leader>n", "<cmd>tabnew<cr>", { silent = true })
vim.keymap.set("n", "<leader>h", "<cmd>tabprevious<cr>", { silent = true })
vim.keymap.set("n", "<leader>l", "<cmd>tabnext<cr>", { silent = true })

-- builtin undotree
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end)
