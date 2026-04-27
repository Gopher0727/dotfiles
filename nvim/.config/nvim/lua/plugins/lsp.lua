vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.enable(
	"lua_ls",
	"gopls",
	"clangd",
	"rust_analyzer",
	"pyright",
	"jsonls",
	"intelephense",
	"marksman",
	"texlab",
	"cmake",
	"kotlin_language_server"
)

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
				disable = { "codestyle-check" },
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
