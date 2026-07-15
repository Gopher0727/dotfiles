vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})

require("snacks").setup({
	bigfile = { enabled = true },
	image = { enabled = true },
	indent = { enabled = true },
	input = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scope = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
})

vim.keymap.set("n", "]w", function()
	Snacks.words.jump(1)
end, { desc = "Next reference" })

vim.keymap.set("n", "[w", function()
	Snacks.words.jump(-1)
end, { desc = "Prev reference" })

vim.keymap.set("n", "]W", function()
	local words, idx = Snacks.words.get()
	if not idx then
		return
	end
	Snacks.words.jump(#words - idx)
end, { desc = "Last reference" })

vim.keymap.set("n", "[W", function()
	local _, idx = Snacks.words.get()
	if not idx then
		return
	end
	Snacks.words.jump(1 - idx)
end, { desc = "First reference" })
