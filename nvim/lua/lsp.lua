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
