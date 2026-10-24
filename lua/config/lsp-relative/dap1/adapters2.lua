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

dap.adapters.csharp = {
	type = "executable",
	command = vim.fn.exepath("netcoredbg"),
	args = { "--interpreter=vscode" },
}

-- mason 的 js-debug-adapter shim 自己 exec node .../dapDebugServer.js "$@"
dap.adapters["pwa-node"] = {
	type = "server",
	host = "127.0.0.1",
	port = "${port}",
	executable = {
		command = vim.fn.expand("~/.local/share/nvim/mason/bin/js-debug-adapter"),
		args = { "${port}" },
	},
}
