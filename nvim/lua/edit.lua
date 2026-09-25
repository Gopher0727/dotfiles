vim.g.mapleader = " "

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

-- C-o 开新行
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

	-- markdown 行内渲染
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
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

---- Yazi
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/mikavilpas/yazi.nvim" },
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
		require("yazi").setup({
			open_for_directories = true,
			floating_window_scaling_factor = 1,
			yazi_floating_window_border = "none",
			integrations = {
				grep_in_directory = "snacks.picker",
				grep_in_selected_files = "snacks.picker",
			},
		})
	end,
})

vim.keymap.set({ "n", "v" }, "<leader>e", "<cmd>Yazi toggle<cr>", { desc = "Toggle Yazi" })
