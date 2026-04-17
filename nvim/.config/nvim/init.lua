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

-- plugin
vim.pack.add {
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
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
require("blink.cmp").setup({
	keymap = {
		['<CR>'] = { 'select_and_accept', 'fallback' },
	},
	fuzzy = {
		implementation = "lua",
	},
})
require("nvim-treesitter").setup({
	install = {
		auto_install = true,
		sync = true,
	},
    install_dir = vim.fn.stdpath("data") .. "/site",
})
require("oil").setup()
require("nvim-autopairs").setup({
	check_ts = true,
	fast_wrap = {},
	disable_filetype = { "TelescopePrompt", "vim" },
})

-- lsp
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
vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork" },
	root_markers = { "go.mod", "go.work", ".git" },
	settings = {
		gopls = {
			staticcheck = true,
			gofumpt = true,
			analyses = {
				unusedparams = true,
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

-- treesitter
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

