-- lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "<leader>fi", vim.lsp.buf.code_action, { desc = "Code actions" })

-- move cursor
vim.keymap.set({ "n", "v" }, "H", "^", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "L", "$", { noremap = true, silent = true })

-- edit window
vim.keymap.set("n", "<leader>n", "<cmd>tabnew<cr>", { silent = true })
vim.keymap.set("n", "<leader>h", "<cmd>tabprevious<cr>", { silent = true })
vim.keymap.set("n", "<leader>l", "<cmd>tabnext<cr>", { silent = true })
vim.keymap.set("n", "<leader>c", "<cmd>tabclose<cr>", { silent = true })

-- builtin undotree
vim.keymap.set("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open()
end)

-- Option + 上下：移动当前行
vim.keymap.set("n", "<M-up>", ":move .-2<cr>==")
vim.keymap.set("n", "<M-down>", ":move .+1<cr>==")
vim.keymap.set("v", "<M-up>", ":move '<-2<cr>gv=gv")
vim.keymap.set("v", "<M-down>", ":move '>+1<cr>gv=gv")

-- Shift + Option + 上下：复制当前行
vim.keymap.set("n", "<M-S-up>", ":t .-1<cr>==")
vim.keymap.set("n", "<M-S-down>", ":t .<cr>==")
vim.keymap.set("v", "<M-S-up>", ":t '<-1<cr>gv=gv")
vim.keymap.set("v", "<M-S-down>", ":t '>+1<cr>gv=gv")
