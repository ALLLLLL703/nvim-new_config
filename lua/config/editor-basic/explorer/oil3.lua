local oil = require("oil")

---@type oil.SetupOpts
local oil_opts = {

	default_file_explorer = true,

	columns = {
		"permissions",
		"size",
		"mtime",
		"icon",
	},

	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},
	lsp_file_methods = {
		enabled = true,
		autosave_changes = false,
		timeout_ms = 2000,
	},
}

oil.setup(oil_opts)
