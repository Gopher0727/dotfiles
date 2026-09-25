require("vim._core.ui2").enable()

vim.o.nu = true
vim.o.rnu = true
vim.o.wrap = false
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"

vim.pack.add({
	-- catppuccin
	{ src = "https://github.com/catppuccin/nvim" },

	-- 顶部导航栏
	{ src = "https://github.com/Bekaboo/dropbar.nvim" },
	-- 底部状态栏
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	-- 彩虹括号
	{ src = "https://github.com/hiphish/rainbow-delimiters.nvim" },
})

require("catppuccin").setup({
	flavour = "mocha", -- latte, frappe, macchiato, mocha
	no_italic = true,
})
vim.cmd.colorscheme("catppuccin-nvim")

require("dropbar").setup({})

require("lualine").setup({})

-- local rainbow_colors = {
--         RainbowDelimiterOrange = "#fab387",
-- 	RainbowDelimiterRed = "#f38ba8",
-- 	RainbowDelimiterYellow = "#f9e2af",
-- 	RainbowDelimiterGreen = "#a6e3a1",
-- 	RainbowDelimiterCyan = "#94e2d5",
-- 	RainbowDelimiterBlue = "#89b4fa",
-- 	RainbowDelimiterViolet = "#cba6f7",
-- }
-- require("rainbow-delimiters.setup").setup({
-- 	strategy = { [""] = "rainbow-delimiters.strategy.global", vim = "rainbow-delimiters.strategy.local" },
-- 	query = { [""] = "rainbow-delimiters", lua = "rainbow-blocks" },
-- 	priority = { [""] = 110, lua = 210 },
-- 	highlight = vim.tbl_keys(rainbow_colors),
-- })
-- for name, color in pairs(rainbow_colors) do
-- 	vim.api.nvim_set_hl(0, name, { fg = color })
-- end

---- Snacks
vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})

local Snacks = require("snacks")

if not Snacks.did_setup then
	Snacks.setup({
		indent = { enabled = true, indent = { char = "▏" }, scope = { enabled = true, char = "▏" } },
		scope = { enabled = true },
		explorer = { enabled = false },
		picker = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		bigfile = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = {
			enabled = true,
			left = { "git", "sign", "mark" },
			right = { "fold" },
		},
		image = { enabled = true },
		animate = { enabled = true },
	})
end

vim.pack.add({
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/jgottzen/ya-tree.nvim" },
})

if vim.lsp.get_clients and vim.lsp.get_active_clients then
	vim.lsp.get_active_clients = vim.lsp.get_clients
end
local YaTree = require("ya-tree")

-- 退出本标签页最后一个普通窗口时，先移除侧栏，让 :q / :wq 正常处理退出。
YaTree.setup({
	close_if_last_window = true,
	follow_focused_file = true,
	hijack_netrw = false, -- 目录仍由 yazi 接管
	sidebar = {
		layout = {
			left = { panels = {}, width = 40 },
			right = {
				panels = {
					{ panel = "files", height = "60%" },
					{ panel = "symbols", height = "40%" },
				},
				width = 40,
			},
		},
	},
})

local symbol_follow_group = vim.api.nvim_create_augroup("YaTreeSymbolFollow", { clear = true })
local symbol_follow_pending = false
local function follow_current_symbol()
	local sidebar = require("ya-tree.sidebar").get_sidebar(vim.api.nvim_get_current_tabpage())
	if not sidebar or not sidebar:is_open() then
		return
	end
	local edit_win = sidebar:edit_win()
	if not edit_win or not vim.api.nvim_win_is_valid(edit_win) or vim.api.nvim_get_current_win() ~= edit_win then
		return
	end
	local panel = sidebar:get_panel("symbols")
	if not panel or not panel:is_open() then
		return
	end
	local bufnr = vim.api.nvim_win_get_buf(edit_win)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	if filename == "" or vim.fs.normalize(panel.root.path) ~= vim.fs.normalize(filename) then
		return
	end
	local row = vim.api.nvim_win_get_cursor(edit_win)[1] - 1
	local current_node
	local current_span = math.huge
	local current_depth = -1
	panel.root:walk(function(node)
		local position = node.position
		if node ~= panel.root and position and position.start and position["end"] then
			local start_line = position.start.line
			local end_line = position["end"].line
			if start_line <= row and row <= end_line then
				local span = end_line - start_line
				local depth = 0
				local parent = node.parent
				while parent do
					depth = depth + 1
					parent = parent.parent
				end
				if span < current_span or (span == current_span and depth > current_depth) then
					current_node = node
					current_span = span
					current_depth = depth
				end
			end
		end
	end)
	if current_node and panel.current_node ~= current_node then
		panel.current_node = current_node
		panel:focus_node(current_node)
	end
end

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = symbol_follow_group,
	callback = function()
		if symbol_follow_pending then
			return
		end
		symbol_follow_pending = true
		vim.schedule(function()
			symbol_follow_pending = false
			follow_current_symbol()
		end)
	end,
})
vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
	group = symbol_follow_group,
	callback = function()
		vim.defer_fn(follow_current_symbol, 250)
	end,
})

---- 文件侧栏（启动偏好仅保存在本机，不随 dotfiles 同步）
local sidebar_state = vim.fn.stdpath("state") .. "/sidebar-auto"
local sidebar_auto = vim.fn.filereadable(sidebar_state) == 0 or vim.fn.readfile(sidebar_state)[1] ~= "off"

local function toggle_sidebar()
	YaTree.toggle()
end

vim.keymap.set("n", "<leader>E", toggle_sidebar, { desc = "Toggle file sidebar" })
vim.api.nvim_create_user_command("SidebarToggle", toggle_sidebar, { desc = "Toggle file sidebar" })
vim.api.nvim_create_user_command("SidebarAuto", function(opts)
	if opts.args ~= "" then
		if opts.args ~= "on" and opts.args ~= "off" then
			vim.notify("Usage: :SidebarAuto [on|off]", vim.log.levels.ERROR)
			return
		end
		vim.fn.mkdir(vim.fn.stdpath("state"), "p")
		vim.fn.writefile({ opts.args }, sidebar_state)
		sidebar_auto = opts.args == "on"
	end
	vim.notify("Sidebar auto-start: " .. (sidebar_auto and "on" or "off"))
end, {
	nargs = "?",
	complete = function()
		return { "on", "off" }
	end,
	desc = "Save this device's sidebar startup preference",
})

local sidebar_group = vim.api.nvim_create_augroup("FileSidebar", { clear = true })
local start_directory = vim.fn.isdirectory(vim.fn.argv(0)) == 1
vim.api.nvim_create_autocmd("VimEnter", {
	group = sidebar_group,
	callback = function()
		if sidebar_auto and not start_directory and #vim.api.nvim_list_uis() > 0 then
			vim.schedule(function()
				YaTree.open({ focus = false, panel = "files" })
			end)
		end
	end,
})

vim.api.nvim_create_autocmd("QuitPre", {
	group = sidebar_group,
	callback = function()
		local current = vim.api.nvim_get_current_win()
		local current_buf = vim.api.nvim_win_get_buf(current)
		if vim.api.nvim_win_get_config(current).relative ~= "" or vim.bo[current_buf].buftype ~= "" then
			return
		end
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if win ~= current and vim.api.nvim_win_get_config(win).relative == "" then
				local buf = vim.api.nvim_win_get_buf(win)
				if vim.bo[buf].buftype == "" then
					return
				end
			end
		end
		YaTree.close()
	end,
})

-- picker
vim.keymap.set("n", "<leader>ff", Snacks.picker.files)
vim.keymap.set("n", "<leader>fg", Snacks.picker.grep)
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers)
vim.keymap.set("n", "<leader>fh", Snacks.picker.help)
vim.keymap.set("n", "<leader>fr", Snacks.picker.registers)
vim.keymap.set("n", "<leader>fc", Snacks.picker.commands)
vim.keymap.set("n", "<leader>fD", Snacks.picker.diagnostics)
vim.keymap.set("n", "<leader>fd", Snacks.picker.diagnostics_buffer)
vim.keymap.set({ "n", "t" }, "<C-/>", Snacks.terminal.toggle)
