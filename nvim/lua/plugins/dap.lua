vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/leoluz/nvim-dap-go" },
	{ src = "https://github.com/mfussenegger/nvim-dap-python" },
	{ src = "https://github.com/Weissle/persistent-breakpoints.nvim" },
})

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- dap debug (使用 persistent-breakpoints 替代原生断点命令)
local pb = require("persistent-breakpoints.api")
require("persistent-breakpoints").setup({
	load_breakpoints_event = { "BufReadPost" },
})

vim.keymap.set("n", "<leader>db", pb.toggle_breakpoint, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })

-- 条件断点
vim.keymap.set("n", "<leader>dB", function()
	pb.set_conditional_breakpoint()
end, { desc = "Conditional breakpoint" })

-- 次数断点
vim.keymap.set("n", "<leader>dH", function()
	local hit = vim.fn.input("Hit condition (e.g. >= 5): ")
	if hit ~= "" then
		dap.set_breakpoint(nil, hit, nil)
	end
end, { desc = "Hit count breakpoint" })

-- 日志断点
vim.keymap.set("n", "<leader>dL", function()
	local msg = vim.fn.input("Log message ({expr} for interpolation): ")
	if msg ~= "" then
		dap.set_breakpoint(nil, nil, msg)
	end
end, { desc = "Log point" })

-- 清除断点
vim.keymap.set("n", "<leader>dX", pb.clear_all_breakpoints, { desc = "Clear all breakpoints" })

-- Go: go install github.com/go-delve/delve/cmd/dlv@latest
require("dap-go").setup({
	dap_configurations = {
		{
			type = "go",
			name = "Debug (with input)",
			request = "launch",
			program = "${file}",
			console = "integratedTerminal",
		},
	},
})

-- Python: uv add --dev debugpy
-- 查找虚拟环境的 python，adapter 和调试目标都用同一个
local function get_python_path()
	if vim.env.VIRTUAL_ENV then
		return vim.env.VIRTUAL_ENV .. "/bin/python"
	end
	local uv_venv = vim.fn.getcwd() .. "/.venv/bin/python"
	if vim.fn.executable(uv_venv) == 1 then
		return uv_venv
	end
	return "python3"
end

require("dap-python").setup(get_python_path())

-- Rust/C/C++: brew install llvm (提供 lldb-dap)
dap.adapters["lldb-dap"] = {
	type = "executable",
	command = "/opt/homebrew/opt/llvm/bin/lldb-dap",
}

dap.configurations.rust = {
	{
		name = "Launch",
		type = "lldb-dap",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
		end,
		cwd = "${workspaceFolder}",
	},
}

dap.configurations.c = {
	{
		name = "Launch",
		type = "lldb-dap",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
	},
}

dap.configurations.cpp = dap.configurations.c
