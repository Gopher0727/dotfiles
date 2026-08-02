vim.g.mapleader = " "

-- ui
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"

-- theme
vim.pack.add({
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
})
require("gruvbox").setup({
	terminal_colors = true,
	italic = {
		strings = false,
		comments = false,
		operators = false,
		folds = false,
		emphasis = false,
	},
})
vim.cmd.colorscheme("gruvbox")

-- tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set(
	"i",
	"<Esc>",
	"<Esc><cmd>nohlsearch<CR>",
	{ noremap = true, desc = "Clear search highlight on leaving insert" }
)

-- 进入 insert 时隐藏搜索高亮。
-- 注意: 0.12 的 TUI 在 mode 切换重绘时会带着旧行缓存重新上色,
-- nohlsearch / hlsearch=false / redraw 都会被覆盖回去;
-- 只能直接改高亮组为透明, 退出 insert 时还原。
local search_hl_def = {}
local cursearch_hl_def = {}
local function save_search_hl()
	search_hl_def = vim.api.nvim_get_hl(0, { name = "Search" })
	cursearch_hl_def = vim.api.nvim_get_hl(0, { name = "CurSearch" })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = save_search_hl })
vim.schedule(save_search_hl)

vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.api.nvim_set_hl(0, "Search", {})
		vim.api.nvim_set_hl(0, "CurSearch", {})
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.api.nvim_set_hl(0, "Search", search_hl_def)
		vim.api.nvim_set_hl(0, "CurSearch", cursearch_hl_def)
	end,
})

-- mouse
vim.opt.mouse = "a"
vim.keymap.set("", "<ScrollWheelLeft>", "<Nop>")
vim.keymap.set("", "<ScrollWheelRight>", "<Nop>")

-- diagnostic
vim.diagnostic.config({
	severity_sort = true,
	virtual_text = true,
	update_in_insert = true,
})

-- Extra
vim.opt.clipboard = "unnamedplus"
vim.opt.exrc = true
vim.opt.autochdir = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.undofile = true
vim.opt.autowrite = true

-- edit 打开文件回到上次编辑位置
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local row = vim.fn.line([['"]])
		if row > 1 and row <= vim.fn.line("$") then
			vim.cmd("normal! g'\"")
		end
	end,
})

-- auto-save
vim.g.auto_save_enabled = true

vim.api.nvim_create_user_command("ASToggle", function()
	vim.g.auto_save_enabled = not vim.g.auto_save_enabled
	vim.notify("Auto-save: " .. (vim.g.auto_save_enabled and "ON" or "OFF"))
end, {})

local autosave_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	group = autosave_group,
	pattern = "*",
	callback = function()
		if not vim.g.auto_save_enabled then
			return
		end
		local buf = vim.api.nvim_get_current_buf()
		if not vim.bo[buf].modifiable or vim.bo[buf].buftype ~= "" then
			return
		end
		local ignored = { TelescopePrompt = true, harpoon = true, NvimTree = true }
		if ignored[vim.bo[buf].filetype] then
			return
		end
		local name = vim.api.nvim_buf_get_name(buf)
		if name == "" or not vim.uv.fs_stat(name) then
			return
		end
		pcall(function()
			vim.cmd("silent! write")
		end)
	end,
})

vim.keymap.set("n", "<leader>as", "<cmd>ASToggle<cr>", { desc = "Toggle auto-save" })

-- lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set({ "n", "v" }, "<leader>fi", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "<leader>fo", function()
	vim.lsp.buf.code_action({
		apply = true,
		context = {
			diagnostics = {},
			only = { "source.organizeImports" },
		},
	})
end, { desc = "Organize Imports" })

-- window
vim.keymap.set("n", "<leader>n", "<cmd>tabnew<cr>", { silent = true })
vim.keymap.set("n", "<leader>h", "<cmd>tabprevious<cr>", { silent = true })
vim.keymap.set("n", "<leader>l", "<cmd>tabnext<cr>", { silent = true })
vim.keymap.set("n", "<leader>c", "<cmd>tabclose<cr>", { silent = true })

-- builtin undotree
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end)

-- edit
vim.keymap.set("i", "<C-CR>", "<C-o>o", { desc = "Open line below" })
vim.keymap.set({ "n", "v" }, "H", "^", { noremap = true, silent = true }) -- 行首（跳到第一个非空白字符）
vim.keymap.set({ "n", "v" }, "L", "$", { noremap = true, silent = true })

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
