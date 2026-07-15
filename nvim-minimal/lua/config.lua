vim.g.mapleader = " "
vim.o.cursorline = true
vim.o.inccommand = "split"
vim.o.clipboard = "unnamedplus"
vim.o.winborder = "rounded"
vim.o.confirm = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

vim.keymap.set("n", "<leader>n", "<cmd>tabnew<cr>")
vim.keymap.set("n", "<leader>h", "<cmd>tabprevious<cr>")
vim.keymap.set("n", "<leader>l", "<cmd>tabnext<cr>")
vim.keymap.set("n", "<leader>c", "<cmd>tabclose<cr>")

vim.keymap.set({ "n", "v" }, "H", "^", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "L", "$", { noremap = true, silent = true })

vim.keymap.set("n", "<M-up>", ":move .-2<cr>==")
vim.keymap.set("n", "<M-down>", ":move .+1<cr>==")
vim.keymap.set("v", "<M-up>", ":move '<-2<cr>gv=gv")
vim.keymap.set("v", "<M-down>", ":move '>+1<cr>gv=gv")

vim.keymap.set("n", "<M-S-up>", ":t .-1<cr>==")
vim.keymap.set("n", "<M-S-down>", ":t .<cr>==")
vim.keymap.set("v", "<M-S-up>", ":t '<-1<cr>gv=gv")
vim.keymap.set("v", "<M-S-down>", ":t '>+1<cr>gv=gv")

vim.lsp.enable({ "lua_ls", "gopls", "clangd", "ty", "rust_analyzer", "zls" })

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim", "Snacks" } },
			workspace = { library = { vim.env.VIMRUNTIME, vim.fn.stdpath("config") } },
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config("clangd", {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork" },
	root_markers = { "go.mod", "go.work", ".git" },
})

vim.lsp.config("ty", {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
})

vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
})

vim.lsp.config("zls", {
	cmd = { "zls" },
	filetypes = { "zig" },
	root_markers = { "build.zig", ".git" },
})

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
