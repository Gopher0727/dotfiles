vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		go = { "goimports-reviser", "gofmt" },
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		rust = { "rustfmt" },
		zig = { "zigfmt" },
		javascript = { "prettier" },
		typescript = { "prettier" },

		json = { "jq" },
		markdown = { "prettier" },

		["_"] = { "trim_whitespace" },
	},
})

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true })
end, { desc = "Format file" })
