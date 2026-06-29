vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/tanvirtin/monokai.nvim" },
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
})

require("tokyonight").setup({
	style = "night",
})
require("catppuccin").setup({
	flavour = "mocha",
})

-- Persist selected theme
local theme_file = vim.fn.stdpath("data") .. "/selected_theme"
local default = "default"
local theme = default
local f = io.open(theme_file, "r")
if f then
	local saved = f:read("*l"):gsub("%s+", "")
	f:close()
	if saved ~= "" and vim.tbl_contains(vim.fn.getcompletion("", "color"), saved) then
		theme = saved
	end
end
vim.cmd.colorscheme(theme)
