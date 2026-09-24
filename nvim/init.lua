require("vim._core.ui2").enable()

vim.g.mapleader = " "

---- ui
vim.o.nu = true
vim.o.rnu = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"

vim.pack.add({
	-- gruvbox
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
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

---- search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>")
vim.keymap.set("i", "<Esc>", "<Esc><cmd>noh<CR>")

---- split
vim.o.splitbelow = true
vim.o.splitright = true

---- edit
vim.o.autoread = true
vim.o.inccommand = "split"
vim.o.clipboard = "unnamedplus"
vim.o.confirm = true
vim.o.undofile = true
vim.o.swapfile = false
vim.o.softtabstop = 8
vim.o.expandtab = true
vim.o.autowriteall = true
vim.o.exrc = true
vim.o.secure = true

-- Option + 上下：移动当前行
vim.keymap.set("n", "<M-up>", ":move .-2<cr>==")
vim.keymap.set("n", "<M-down>", ":move .+1<cr>==")
vim.keymap.set("v", "<M-up>", ":move '<-2<cr>gv=gv")
vim.keymap.set("v", "<M-down>", ":move '>+1<cr>gv=gv")
vim.keymap.set("i", "<M-up>", "<Esc>:move .-2<CR>==gi")
vim.keymap.set("i", "<M-down>", "<Esc>:move .+1<CR>==gi")

-- Shift + Option + 上下：复制当前行
vim.keymap.set("n", "<M-S-up>", ":t .-1<cr>==")
vim.keymap.set("n", "<M-S-down>", ":t .<cr>==")
vim.keymap.set("v", "<M-S-up>", ":t '<-1<cr>gv=gv")
vim.keymap.set("v", "<M-S-down>", ":t '>+1<cr>gv=gv")
vim.keymap.set("i", "<M-S-up>", "<Esc>:t .-1<CR>==gi")
vim.keymap.set("i", "<M-S-down>", "<Esc>:t .<CR>==gi")

-- Shift + H / L：行首 / 行尾（覆盖默认的屏幕顶部/底部）
vim.keymap.set("n", "H", "^", { desc = "Go to line start" })
vim.keymap.set("n", "L", "$", { desc = "Go to line end" })
vim.keymap.set("v", "H", "^", { desc = "Go to line start" })
vim.keymap.set("v", "L", "$", { desc = "Go to line end" })

-- Ctrl + Enter：开新行
vim.keymap.set("i", "<C-CR>", "<C-o>o", { desc = "Open line below" })

-- 打开文件回到上次退出的位置
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local row = vim.fn.line([['"]])
		if row > 1 and row <= vim.fn.line("$") then
			vim.cmd("normal! g'\"")
		end
	end,
})

vim.pack.add({
	-- 自动括号补全
	{ src = "https://github.com/windwp/nvim-autopairs" },
	-- 格式化
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("nvim-autopairs").setup({ check_ts = true, disable_filetype = { "snacks_picker_input", "vim" } })

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		go = { "goimports-reviser", "goimports", "gofmt" },
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		rust = { "rustfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		cuda = { "clang-format" },
		php = { "php_cs_fixer" },
		json = { "jq" },
		jsonl = { "jq" },
		markdown = { "prettier" },
		["_"] = { "trim_whitespace" },
	},
})

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format file" })

vim.keymap.set("v", "<leader>cs", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format selection" })

---- Treesitter
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
})

require("nvim-treesitter").install({
	"lua",
	"go",
	"rust",
	"c",
	"cpp",
	"python",
	"vim",
	"php",
	"phpdoc",
	"markdown",
	"markdown_inline",
})

---- markdown 行内渲染
vim.pack.add({
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

require("render-markdown").setup({})

---- git signs
vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 0,
		virt_text = true,
		virt_text_pos = "eol",
	},
})

vim.keymap.set("n", "<leader>gp", function()
	require("gitsigns").preview_hunk()
end, { desc = "Preview Git Hunk" })

---- Snacks
vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})

local Snacks = require("snacks")

if not Snacks.did_setup then
	Snacks.setup({
		indent = { enabled = true, indent = { char = "▏" }, scope = { enabled = true, char = "▏" } },
		scope = { enabled = true },
		explorer = { enabled = true, replace_netrw = false }, -- 目录仍由 yazi 接管
		picker = {
			enabled = true,
			sources = {
				explorer = {
					layout = { preset = "sidebar", preview = false, hidden = { "input" } },
				},
			},
		},
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

---- 文件侧栏（启动偏好仅保存在本机，不随 dotfiles 同步）
local sidebar_state = vim.fn.stdpath("state") .. "/sidebar-auto"
local sidebar_auto = vim.fn.filereadable(sidebar_state) == 0 or vim.fn.readfile(sidebar_state)[1] ~= "off"

local function toggle_sidebar()
	local pickers = Snacks.picker.get({ source = "explorer" })
	if #pickers == 0 then
		Snacks.explorer()
	else
		for _, picker in ipairs(pickers) do
			picker:close()
		end
	end
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
vim.api.nvim_create_autocmd("VimEnter", {
	group = sidebar_group,
	callback = function()
		if sidebar_auto and #vim.api.nvim_list_uis() > 0 then
			vim.schedule(function()
				Snacks.explorer({ focus = false })
			end)
		end
	end,
})

-- 退出本标签页最后一个普通窗口时，先移除侧栏，让 :q / :wq 正常处理退出。
vim.api.nvim_create_autocmd("QuitPre", {
	group = sidebar_group,
	callback = function()
		local pickers = Snacks.picker.get({ source = "explorer" })
		local sidebar_windows = {}
		for _, picker in ipairs(pickers) do
			for _, win in pairs(picker.layout:get_wins()) do
				if win.win then
					sidebar_windows[win.win] = true
				end
			end
		end
		local current = vim.api.nvim_get_current_win()
		if sidebar_windows[current] or vim.api.nvim_win_get_config(current).relative ~= "" then
			return
		end
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if win ~= current and not sidebar_windows[win] and vim.api.nvim_win_get_config(win).relative == "" then
				return
			end
		end
		for _, picker in ipairs(pickers) do
			picker:close()
			picker.layout:close() -- picker:close() 的布局清理是异步的，这里需在 :q 前完成
		end
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

---- Yazi
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/mikavilpas/yazi.nvim" },
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("yazi").setup({
	open_for_directories = true,
	floating_window_scaling_factor = 1,
	yazi_floating_window_border = "none",
	integrations = {
		grep_in_directory = "snacks.picker",
		grep_in_selected_files = "snacks.picker",
	},
})

vim.keymap.set({ "n", "v" }, "<leader>e", "<cmd>Yazi toggle<cr>", { desc = "Toggle Yazi" })

---- LSP
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.enable({ "lua_ls", "gopls", "clangd", "rust_analyzer", "basedpyright", "phpantom" })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim", "Snacks" }, disable = { "codestyle-check" } },
			hint = { enable = false },
			workspace = { library = { vim.env.VIMRUNTIME, vim.fn.stdpath("config") } },
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config("gopls", {
	settings = {
		gopls = {
			staticcheck = true,
			usePlaceholders = true,
			analyses = { unusedparams = true, unusedvariable = true, shadow = true, nilness = true, unusedwrite = true },
		},
	},
})

vim.lsp.config("clangd", { cmd = { "clangd", "--function-arg-placeholders=1" } })

vim.lsp.config("phpantom", {
	cmd = { "phpantom_lsp" },
	filetypes = { "php" },
	root_markers = { "composer.json", ".git" },
})

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set({ "n", "v" }, "<leader>fi", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "<leader>fo", function()
	vim.lsp.buf.code_action({
		apply = true,
		context = {
			diagnostics = {},
			only = { "source.organizeImports" },
		},
	})
end, { desc = "Organize imports" })

---- 补全
-- 注意：vim.pack.add 不跑构建，重装插件后需手动编译原生库：
--   nvim --headless "+lua require('blink.cmp').build():pwait()" +qa
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/saghen/blink.lib" },
})

-- 如果使用了万能头文件，就不再自动补全头文件
local function uses_universal_header(bufnr)
	for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 200, false)) do
		if line:match('^%s*#%s*include%s*[<"]bits/stdc%+%+') then
			return true
		end
	end
	return false
end

require("blink.cmp").setup({
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = { list = { selection = { preselect = true, auto_insert = false } } },
	keymap = {
		preset = "none",
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = false,
		["<S-Tab>"] = false,
	},
	sources = {
		transform_items = function(ctx, items)
			if ctx.mode ~= "default" or not uses_universal_header(ctx.bufnr) then
				return items
			end
			for _, item in ipairs(items) do
				if item.additionalTextEdits ~= nil then
					item.additionalTextEdits = nil
					if item.label ~= nil and item.label:sub(1, #"•") == "•" then
						item.label = " " .. item.label:sub(#"•" + 1)
					end
				end
			end
			return items
		end,
		min_keyword_length = 2,
		default = { "lsp", "path", "buffer" },
		providers = {
			lsp = { fallbacks = {} },
			path = { fallbacks = {} },
		},
	},
	term = {
		enabled = false,
	},
	cmdline = {
		keymap = {
			preset = "none",
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = false,
			["<S-Tab>"] = false,
		},
		completion = {
			list = { selection = { preselect = false, auto_insert = false } },
			menu = { auto_show = true },
		},
	},
})
