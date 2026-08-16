require("vim._core.ui2").enable()

vim.g.mapleader = " "

---- ui
vim.o.nu = true
vim.o.rnu = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"

-- theme
vim.pack.add({
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
})
vim.cmd.colorscheme("gruvbox")

-- vim.cmd.colorscheme("catppuccin")

-- 顶部导航栏
vim.pack.add({
	{ src = "https://github.com/Bekaboo/dropbar.nvim" },
})

require("dropbar").setup({})

-- 底部状态栏
vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

require("lualine").setup()

-- Treesitter
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
})

require("nvim-treesitter").install({ "lua", "go", "rust", "c", "cpp", "python", "vim" })

-- Snacks
vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})

if not require("snacks").did_setup then
	require("snacks").setup({
		indent = { enabled = true, indent = { char = "▏" }, scope = { enabled = true, char = "▏" } },
		scope = { enabled = true },
		picker = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		bigfile = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		image = { enabled = true },
		animate = { enabled = true },
	})
end

vim.keymap.set("n", "<leader>fd", function()
	require("snacks.picker").diagnostics()
end, { desc = "Diagnostics (workspace)" })

vim.keymap.set("n", "<leader>fD", function()
	require("snacks.picker").diagnostics_buffer()
end, { desc = "Diagnostics (buffer)" })

-- Snacks 终端: <leader>t 切换底部终端面板
vim.keymap.set("n", "<leader>t", function()
	require("snacks.terminal").toggle()
end, { desc = "Toggle terminal" })

-- 彩虹括号
vim.pack.add({
	{ src = "https://github.com/hiphish/rainbow-delimiters.nvim" },
})

require("rainbow-delimiters.setup").setup({
	strategy = { [""] = "rainbow-delimiters.strategy.global", vim = "rainbow-delimiters.strategy.local" },
	query = { [""] = "rainbow-delimiters", lua = "rainbow-blocks" },
	priority = { [""] = 110, lua = 210 },
	highlight = {
		"RainbowDelimiterRed",
		"RainbowDelimiterOrange",
		"RainbowDelimiterYellow",
		"RainbowDelimiterGreen",
		"RainbowDelimiterCyan",
		"RainbowDelimiterBlue",
		"RainbowDelimiterViolet",
	},
})

local rainbow_colors = {
	RainbowDelimiterRed = "#f38ba8",
	RainbowDelimiterOrange = "#fab387",
	RainbowDelimiterYellow = "#f9e2af",
	RainbowDelimiterGreen = "#a6e3a1",
	RainbowDelimiterCyan = "#94e2d5",
	RainbowDelimiterBlue = "#89b4fa",
	RainbowDelimiterViolet = "#cba6f7",
}
for name, color in pairs(rainbow_colors) do
	vim.api.nvim_set_hl(0, name, { fg = color })
end

-- Oil
vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("oil").setup({ columns = { "permissions", "size", "mtime", "icon" } })

vim.keymap.set("n", "<leader>o", function()
	if vim.bo.filetype == "oil" then
		require("oil").close()
	else
		require("oil").open()
	end
end, { desc = "Toggle Oil" })

---- search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>")
vim.keymap.set("i", "<Esc>", "<Esc><cmd>noh<CR>")

local picker = require("snacks.picker")
vim.keymap.set("n", "<leader>ff", picker.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", picker.grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", picker.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", picker.help, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", picker.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>fc", picker.commands, { desc = "Commands" })

---- split
vim.o.splitbelow = true
vim.o.splitright = true

---- edit
vim.o.inccommand = "split"
vim.o.clipboard = "unnamedplus"
vim.o.confirm = true
vim.o.undofile = true
vim.o.swapfile = false
vim.o.autowriteall = true
vim.o.softtabstop = 8
vim.o.expandtab = true
vim.keymap.set("i", "<C-CR>", "<C-o>o", { desc = "Open line below" })

-- 自动括号补全
vim.pack.add({
	{ src = "https://github.com/windwp/nvim-autopairs" },
})

require("nvim-autopairs").setup({ check_ts = true, disable_filetype = { "snacks_picker_input", "vim" } })

-- Option + 上下：移动当前行
vim.keymap.set("n", "<M-up>", ":move .-2<cr>==")
vim.keymap.set("n", "<M-down>", ":move .+1<cr>==")
vim.keymap.set("v", "<M-up>", ":move '<-2<cr>gv=gv")
vim.keymap.set("v", "<M-down>", ":move '>+1<cr>gv=gv")

-- Shift + Option + 上下：复制当前行
vim.keymap.set("n", "<M-S-up>", ":t .-1<cr>==")
vim.keymap.set("n", "<M-S-down>", ":t .<cr>==")
vim.keymap.set("v", "<M-S-up>", ":t '<-1<cr>gv=gv")
vim.keymap.set("v", "<M-S-down>", ":t '>+1<cr>gv=gv")

-- Shift + H / L：行首 / 行尾（覆盖默认的屏幕顶部/底部）
vim.keymap.set("n", "H", "^", { desc = "Go to line start" })
vim.keymap.set("n", "L", "$", { desc = "Go to line end" })
vim.keymap.set("v", "H", "^", { desc = "Go to line start" })
vim.keymap.set("v", "L", "$", { desc = "Go to line end" })

-- 格式化
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

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
                markdown = {"prettier"},
		["_"] = { "trim_whitespace" },
	},
})

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format file" })

-- 补全
-- 注意：vim.pack.add 不跑构建，重装插件后需手动编译原生库：
--   nvim --headless "+lua require('blink.cmp').build():pwait()" +qa
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/saghen/blink.lib" },
})

require("blink.cmp").setup({
	appearance = {
		nerd_font_variant = "mono", -- 候选类型图标 (函数/变量/关键字等), 同 LazyVim 配置
	},
	completion = { list = { selection = { preselect = true, auto_insert = false } } },
	keymap = {
		preset = "none",
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<CR>"] = { "accept", "fallback" },
	},
	sources = { default = { "lsp", "path" } },
})

-- 环绕编辑
vim.pack.add({
	{ src = "https://github.com/kylechui/nvim-surround", version = vim.version.range("4.x") },
})

vim.g.nvim_surround_no_normal_mappings = true
vim.g.nvim_surround_no_visual_mappings = true

require("nvim-surround").setup({})

vim.keymap.set("n", "sa", "<Plug>(nvim-surround-normal)", { desc = "Add surround (motion)" })
vim.keymap.set("n", "sd", "<Plug>(nvim-surround-delete)", { desc = "Delete surround" })
vim.keymap.set("n", "sr", "<Plug>(nvim-surround-change)", { desc = "Change surround" })
vim.keymap.set("x", "s", "<Plug>(nvim-surround-visual)", { desc = "Add surround (visual)" })

-- 多光标
vim.pack.add({ { src = "https://github.com/brenton-leighton/multiple-cursors.nvim" } })

require("multiple-cursors").setup()

vim.keymap.set({ "n", "x" }, "<C-n>", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", { desc = "Add cursor at next cword" })
vim.keymap.set({ "n", "x" }, "g<C-n>", "<Cmd>MultipleCursorsAddMatches<CR>")
vim.keymap.set({ "n", "x" }, "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", { desc = "Add cursor below" })
vim.keymap.set({ "n", "x" }, "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", { desc = "Add cursor above" })

---- LSP
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.enable({ "lua_ls", "gopls", "clangd", "rust_analyzer", "pyright" })

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

-- LSP HotKeys
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
