vim.pack.add({
	{ src = "https://github.com/jake-stewart/multicursor-nvim.nvim" },
})

require("multicursor-nvim").vim.keymap.setup({})

-- 上下添加/跳过光标
vim.keymap.set({ "n", "x" }, "<up>", function()
	require("multicursor-nvim").lineAddCursor(-1)
end)
vim.keymap.set({ "n", "x" }, "<down>", function()
	require("multicursor-nvim").lineAddCursor(1)
end)
vim.keymap.set({ "n", "x" }, "<leader><up>", function()
	require("multicursor-nvim").lineSkipCursor(-1)
end)
vim.keymap.set({ "n", "x" }, "<leader><down>", function()
	require("multicursor-nvim").lineSkipCursor(1)
end)

-- 匹配添加/跳过光标
vim.keymap.set({ "n", "x" }, "<a-up>", function()
	require("multicursor-nvim").matchAddCursor(1)
end)
vim.keymap.set({ "n", "x" }, "<a-down>", function()
	require("multicursor-nvim").matchSkipCursor(1)
end)

-- 鼠标添加光标
vim.keymap.set("n", "<c-leftmouse>", require("multicursor-nvim").handleMouse)
vim.keymap.set("n", "<c-leftdrag>", require("multicursor-nvim").handleMouseDrag)
vim.keymap.set("n", "<c-leftrelease>", require("multicursor-nvim").handleMouseRelease)

-- 开关光标
vim.keymap.set({ "n", "x" }, "<c-q>", require("multicursor-nvim").toggleCursor)

-- 仅在多光标模式生效的按键层
require("multicursor-nvim").addKeymapLayer(function(layerSet)
	layerSet.keymap.set({ "n", "x" }, "<left>", require("multicursor-nvim").prevCursor)
	layerSet.keymap.set({ "n", "x" }, "<right>", require("multicursor-nvim").nextCursor)
	layerSet.keymap.set({ "n", "x" }, "<leader>x", require("multicursor-nvim").deleteCursor)
	layerSet.keymap.set("n", "<esc>", function()
		if not require("multicursor-nvim").cursorsEnabled() then
			require("multicursor-nvim").enableCursors()
		else
			require("multicursor-nvim").clearCursors()
		end
	end)
end)

-- 光标外观
local hl = vim.api.nvim_vim.keymap.set_hl
hl(0, "multicursor-nvimCursor", { reverse = true })
hl(0, "multicursor-nvimVisual", { link = "Visual" })
hl(0, "multicursor-nvimSign", { link = "SignColumn" })
hl(0, "multicursor-nvimMatchPreview", { link = "Search" })
hl(0, "multicursor-nvimDisabledCursor", { reverse = true })
hl(0, "multicursor-nvimDisabledVisual", { link = "Visual" })
hl(0, "multicursor-nvimDisabledSign", { link = "SignColumn" })
