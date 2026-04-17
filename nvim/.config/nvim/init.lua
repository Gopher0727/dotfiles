-- nvim 0.12+

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse = 'a'
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.autochdir = true
vim.opt.updatetime = 200
vim.opt.termguicolors = true
vim.opt.winborder = 'rounded'
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.autowrite = true

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
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
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
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
		"gopls",
	}
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim", "require" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- edit
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local row = vim.fn.line([['"]])
		if row > 1 and row <= vim.fn.line("$") then
			vim.cmd("normal! g'\"")
		end
	end
})

