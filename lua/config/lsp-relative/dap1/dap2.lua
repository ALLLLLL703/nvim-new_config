local mason_dap = require("mason-nvim-dap")
local dap = require("dap")
local ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

-- Dap Virtual Text
dap_virtual_text.setup({})

mason_dap.setup({
	ensure_installed = { "cppdbg" },
	automatic_installation = true,
	handlers = {
		function(config)
			require("mason-nvim-dap").default_setup(config)
		end,
	},
})

dap.adapters.codelldb_server = {
	type = "server",
	port = "${port}",
	command = vim.fn.expand("~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb"), -- adjust as needed, must be absolute path
	args = { "--port", "${port}" },
	name = "codelldb_server",
}

dap.adapters.codelldb = {
	type = "executable",
	command = vim.fn.expand("~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb"), -- adjust as needed, must be absolute path
	args = {},
	name = "codelldb",
}
dap.adapters.cpptool = {
	type = "executable",
	command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
	name = "cpptool",
	options = {
		detached = false,
	},
}

dap.adapters.kotlin = {
	type = "executable",
	command = vim.fn.expand("~/.local/share/nvim/mason/bin/kotlin-debug-adapter"),
}

-- Configurations
dap.configurations = {
	c = {
		{
			name = "Launch file",
			type = "cppdbg",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopAtEntry = false,
			MIMode = "gdb",
			args = function()
				local str = vim.fn.input("Arguments:")
				return vim.split(str, " ")
			end,
		},
		{
			name = "Attach to lldbserver :1234",
			type = "cppdbg",
			request = "launch",
			MIMode = "gdb",
			miDebuggerServerAddress = "localhost:1234",
			miDebuggerPath = "/usr/bin/gdb",
			cwd = "${workspaceFolder}",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
		},
	},
	cpp = {
		{
			name = "Launch",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = function()
				local str = vim.fn.input("Arguments:")
				return vim.split(str, " ")
			end,
		},
	},

	rust = {
		{
			name = "Launch",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = function()
				local str = vim.fn.input("Arguments")
				return vim.split(str, " ")
			end,
		},
	},
	-- java = {
	-- 	{
	-- 		type = "java",
	-- 		request = "attach",
	-- 		name = "Attach to Minecraft Server",
	-- 		hostName = "127.0.0.1",
	-- 		port = 5005,
	-- 	},
	-- },
	--
}

-- Dap UI

ui.setup()

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
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end

require("dap.ext.vscode").load_launchjs(nil, {
	codelldb = { "rust" },
})
