vim.pack.add({
	{ src = "https://github.com/toppair/peek.nvim" },
})

require("peek").setup()

vim.api.nvim_create_user_command("PeekOpen", function()
	require("peek").open()
end, {})

vim.api.nvim_create_user_command("PeekClose", function()
	require("peek").close()
end, {})
