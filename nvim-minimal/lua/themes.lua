vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/tanvirtin/monokai.nvim" },
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
	{ src = "https://github.com/marko-cerovac/material.nvim" },
})

require("tokyonight").setup({ style = "night" })
require("catppuccin").setup({ flavour = "mocha" })

-- Persist selected theme
local theme_file = vim.fn.stdpath("data") .. "/selected_theme"
local default = "tokyonight"
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

-- 主题预览选择器
vim.keymap.set("n", "<leader>fC", function()
	local themes = vim.fn.getcompletion("", "color")
	require("telescope.pickers").new({}, {
		prompt_title = "Themes",
		finder = require("telescope.finders").new_table({ results = themes }),
		sorter = require("telescope.config").values.generic_sorter({}),
		previewer = require("telescope.previewers").new_buffer_previewer({
			define_preview = function(_, entry)
				pcall(vim.cmd.colorscheme, entry.value)
			end,
		}),
		attach_mappings = function(prompt_bufnr)
			local actions = require("telescope.actions")
			local state = require("telescope.actions.state")
			actions.select_default:replace(function()
				local selection = state.get_selected_entry()
				actions.close(prompt_bufnr)
				if selection then
					local ok = pcall(vim.cmd.colorscheme, selection.value)
					if ok then
						local f = io.open(theme_file, "w")
						if f then
							f:write(selection.value)
							f:close()
						end
					end
				end
			end)
			return true
		end,
	}):find()
end, { desc = "Switch theme" })
