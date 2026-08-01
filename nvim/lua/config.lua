vim.g.mapleader = " "

-- theme
vim.pack.add({
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
})
require("gruvbox").setup({
	terminal_colors = true,
	italic = {
		strings = false,
		comments = false,
		operators = false,
		folds = false,
		emphasis = false,
	},
})
vim.cmd.colorscheme("gruvbox")

-- ui
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"

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

-- mouse
vim.opt.mouse = "a"
vim.keymap.set("", "<ScrollWheelLeft>", "<Nop>")
vim.keymap.set("", "<ScrollWheelRight>", "<Nop>")

-- diagnostic
vim.diagnostic.config({ severity_sort = true })

-- Extra
vim.opt.clipboard = "unnamedplus"
vim.opt.exrc = true
vim.opt.autochdir = true
vim.opt.scrolloff = 10
vim.opt.confirm = true

-- edit 打开文件回到上次编辑位置
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local row = vim.fn.line([['"]])
		if row > 1 and row <= vim.fn.line("$") then
			vim.cmd("normal! g'\"")
		end
	end,
})
