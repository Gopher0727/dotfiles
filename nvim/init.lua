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

local rainbow_colors = {
	RainbowDelimiterRed = "#f38ba8",
	RainbowDelimiterOrange = "#fab387",
	RainbowDelimiterYellow = "#f9e2af",
	RainbowDelimiterGreen = "#a6e3a1",
	RainbowDelimiterCyan = "#94e2d5",
	RainbowDelimiterBlue = "#89b4fa",
	RainbowDelimiterViolet = "#cba6f7",
}
require("rainbow-delimiters.setup").setup({
	strategy = { [""] = "rainbow-delimiters.strategy.global", vim = "rainbow-delimiters.strategy.local" },
	query = { [""] = "rainbow-delimiters", lua = "rainbow-blocks" },
	priority = { [""] = 110, lua = 210 },
	highlight = vim.tbl_keys(rainbow_colors),
})
for name, color in pairs(rainbow_colors) do
	vim.api.nvim_set_hl(0, name, { fg = color })
end

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
	-- 多光标
	{ src = "https://github.com/brenton-leighton/multiple-cursors.nvim" },
	-- 格式化
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("nvim-autopairs").setup({ check_ts = true, disable_filetype = { "snacks_picker_input", "vim" } })

require("multiple-cursors").setup()

vim.keymap.set({ "n", "x" }, "<C-n>", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", { desc = "Add cursor at next cword" })
vim.keymap.set({ "n", "x" }, "g<C-n>", "<Cmd>MultipleCursorsAddMatches<CR>")
vim.keymap.set({ "n", "x" }, "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", { desc = "Add cursor below" })
vim.keymap.set({ "n", "x" }, "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", { desc = "Add cursor above" })

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

require("nvim-treesitter").install({ "lua", "go", "rust", "c", "cpp", "python", "vim", "php", "phpdoc" })

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

---- Oil
vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("oil").setup({ columns = { "permissions", "size", "mtime", "icon" } })

vim.keymap.set("n", "<leader>e", function()
	if vim.bo.filetype == "oil" then
		require("oil").close()
	else
		require("oil").open()
	end
end, { desc = "Toggle Oil" })

---- LSP
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.enable({ "lua_ls", "gopls", "clangd", "rust_analyzer", "pyright", "phpantom" })

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
