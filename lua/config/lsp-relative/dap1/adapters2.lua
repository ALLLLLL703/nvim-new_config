local dap = require("dap")

dap.adapters.codelldb_server = {
	type = "server",
	port = "${port}",
	command = vim.fn.expand("~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb"),
	args = { "--port", "${port}" },
	name = "codelldb_server",
}

dap.adapters.codelldb = {
	type = "executable",
	command = vim.fn.expand("~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb"),
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
