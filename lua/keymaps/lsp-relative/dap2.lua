local dap_keymaps = {
	d = {
		name = "DAP",
		R = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to cursor" },
		E = { "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", "Evaluate input" },
		C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Set conditional breakpoint" },
		U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle debug UI" },
		b = { "<cmd>lua require'dap'.step_back()<cr>", "Step back" },
		c = { "<cmd>lua require'dap'.continue()<cr>", "Continue debugging" },
		d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect debugger" },
		e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate expression" },
		g = { "<cmd>lua require'dap'.session()<cr>", "Get debug session" },
		h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover variables" },
		S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Show scopes" },
		i = { "<cmd>lua require'dap'.step_into()<cr>", "Step into" },
		o = { "<cmd>lua require'dap'.step_over()<cr>", "Step over" },
		p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause debugging" },
		q = { "<cmd>lua require'dap'.close()<cr>", "Quit debugging" },
		r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle REPL" },
		s = { "<cmd>lua require'dap'.continue()<cr>", "Start debugging" },
		t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle breakpoint" },
		x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate debugging" },
		u = { "<cmd>lua require'dap'.step_out()<cr>", "Step out" },
	},
}

local prefix = "<leader>d"
for key, value in pairs(dap_keymaps.d) do
	if type(value[1]) == "string" then
		vim.keymap.set("n", prefix .. key, value[1], { desc = value[2], silent = true })
	end
end
