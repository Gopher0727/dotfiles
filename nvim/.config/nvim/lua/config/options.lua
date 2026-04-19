vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.autochdir = true
vim.opt.updatetime = 200
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.autowrite = true
vim.opt.signcolumn = "yes"

-- tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- search
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- diagnostic
vim.diagnostic.config({
	signs = true,
	underline = true,
	-- virtual_text = true,
	severity_sort = true,
})

