local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

vim.api.nvim_set_hl(0, "DapBreakpoint", {
	bold = true,
	fg = "#008000",
})
vim.api.nvim_set_hl(0, "DapConditionalBreakpoint", {
	bold = true,
	fg = "#00ffff",
})
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapConditionalBreakpoint" })
vim.fn.sign_define("DapStopped", { text = "🛑" })
vim.fn.sign_define("DapBreakpointRejected", { text = "󰇪" })

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end
