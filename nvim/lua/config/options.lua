vim.g.mapleader = " "

-- ui
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.signcolumn = "yes"

-- file
vim.opt.undofile = true
vim.opt.autowrite = true

-- tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- incremental
vim.opt.inccommand = "split"
vim.opt.exrc = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.autochdir = true
vim.opt.winborder = "rounded"
vim.opt.scrolloff = 10
vim.opt.confirm = true

-- diagnostic
vim.diagnostic.config({
	severity_sort = true,
})
