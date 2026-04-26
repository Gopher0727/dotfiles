vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

vim.keymap.set({ "n" }, "<leader>cf", function()
	require("conform").format({
		async = true,
		lsp_fallback = true,
		timeout_ms = 500,
	})
end, { desc = "Format file" })
