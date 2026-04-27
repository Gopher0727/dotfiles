vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "goimports-reviser", "goimports", "gofmt" },
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		rust = { "rustfmt", lsp_format = "fallback" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		php = { "php_cs_fixer" },
		kotlin = { "ktlint" },
		markdown = { "prettier" },
		tex = { "latexindent" },
		json = { "prettier" },
		cmake = { "cmake_format" },

		["_"] = { "trim_whitespace" },
	},
})

vim.keymap.set({ "n" }, "<leader>cf", function()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
	})
end, { desc = "Format file" })
