vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.enable({
	"lua_ls",
	"gopls",
	"clangd",
	"rust_analyzer",
	"pyright",
})

vim.lsp.config("gopls", {
	settings = {
		gopls = {
			staticcheck = true,
			analyses = {
				unusedparams = true,
				unusedvariable = true,
				shadow = true,
				nilness = true,
				unusedwrite = true,
			},
		},
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim", "Snacks" },
				disable = { "codestyle-check" },
			},
			hint = {
				enable = false,
			},
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					vim.fn.stdpath("config"),
				},
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
