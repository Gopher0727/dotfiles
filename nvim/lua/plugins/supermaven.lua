vim.pack.add({
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
})

-- 阻止 setup 自动启动，不弹提示
local api = require("supermaven-nvim.api")
local real_start = api.start
api.start = function() end

require("supermaven-nvim").setup({
	disable_keymaps = true,
	log_level = "off",
})

api.start = real_start  -- 还原，让 Toggle 正常工作

vim.keymap.set("n", "<leader>am", "<cmd>SupermavenToggle<cr>", { desc = "Toggle Supermaven" })
