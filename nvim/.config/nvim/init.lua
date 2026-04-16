-- nvim 0.12+

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse = 'a'

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

-- theme
vim.pack.add {
    "http://github.com/catppuccin/nvim",
}
vim.cmd.colorscheme("catppuccin-mocha")

-- lsp
vim.pack.add {
    { src = "https://github.com/mason-org/mason.nvim", name = "mason" },
}
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

