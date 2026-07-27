Safe_Require("overseer").setup({

	dap = true,
	component_aliases = {
		-- Most tasks are initialized with the default components
		default = {
			"on_exit_set_status",
			"on_complete_notify",
			{ "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
		},
		-- Tasks from tasks.json use these components
		default_vscode = {
			"default",
			"on_result_diagnostics",
		},
		-- Tasks created from experimental_wrap_builtins
		default_builtin = {
			"on_exit_set_status",
			"on_complete_dispose",
			{ "unique", soft = true },
		},
	},
})
