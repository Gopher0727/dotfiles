vim.pack.add({
	{ src = "https://github.com/toppair/peek.nvim" },
})

require("peek").setup({
	auto_load = true,
	close_on_bdelete = true,
	syntax = true,
	theme = "dark",
	update_on_change = true,
	filetype = { "markdown" },
	throttle_time = "auto",
})

vim.api.nvim_create_user_command("PeekOpen", function()
	require("peek").open()
end, {})

vim.api.nvim_create_user_command("PeekClose", function()
	require("peek").close()
end, {})
