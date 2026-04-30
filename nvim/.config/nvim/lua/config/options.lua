vim.g.mapleader = " "

-- ui
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"

-- file
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.autowrite = true

-- tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- search
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- incremental
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.exrc = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.autochdir = true
vim.opt.updatetime = 200
vim.opt.winborder = "rounded"
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.g.editorconfig = true

-- diagnostic
vim.diagnostic.config({
	signs = true,
	underline = true,
	-- virtual_text = true,
	severity_sort = true,
})
