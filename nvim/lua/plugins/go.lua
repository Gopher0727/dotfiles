vim.pack.add({
	{ src = "https://github.com/ray-x/guihua.lua" },
	{ src = "https://github.com/ray-x/go.nvim" },
})

require("go").setup({
	lsp_cfg = true,
	ai = false,
	lsp_inlay_hints = {
		enable = true,
	},
	gopls_cfg = {
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
})
