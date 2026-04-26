vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT"
			},
			diagnostics = {
				globals = {
					"vim",
					"require"
				},
				disable = {
					"codestyle-check"
				}
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false
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
				unusedvariable = true,
				shadow = true,
				nilness = true,
				unusedwrite = true,
			},
		},
	},
})
