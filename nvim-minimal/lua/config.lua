vim.g.mapleader = " "
vim.o.cursorline = true
vim.o.inccommand = "split"
vim.o.clipboard = "unnamedplus"
vim.o.winborder = "rounded"
vim.o.confirm = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

vim.keymap.set("n", "<leader>n", "<cmd>tabnew<cr>")
vim.keymap.set("n", "<leader>h", "<cmd>tabprevious<cr>")
vim.keymap.set("n", "<leader>l", "<cmd>tabnext<cr>")
vim.keymap.set("n", "<leader>c", "<cmd>tabclose<cr>")

vim.keymap.set({ "n", "v" }, "H", "^", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "L", "$", { noremap = true, silent = true })

vim.keymap.set("n", "<M-up>", ":move .-2<cr>==")
vim.keymap.set("n", "<M-down>", ":move .+1<cr>==")
vim.keymap.set("v", "<M-up>", ":move '<-2<cr>gv=gv")
vim.keymap.set("v", "<M-down>", ":move '>+1<cr>gv=gv")

vim.keymap.set("n", "<M-S-up>", ":t .-1<cr>==")
vim.keymap.set("n", "<M-S-down>", ":t .<cr>==")
vim.keymap.set("v", "<M-S-up>", ":t '<-1<cr>gv=gv")
vim.keymap.set("v", "<M-S-down>", ":t '>+1<cr>gv=gv")
