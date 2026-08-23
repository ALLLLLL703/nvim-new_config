require("config.lsp-relative.kotlin2.jetbrains1")

require("jet-kotlin").setup({
	server = {
		mode = "path",
		path = vim.fn.expand("~/.local/share/nvim/mason/bin/intellij-server"),
		version = "v262.9593.0",
		auto_update = false,
	},
	--[[ project = {
		build_tool = nil, -- nil: auto-detect; '': disable project import
		default_sdk = "/absolute/path/to/jdk",
		auto_reload = true,
	}, ]]
	editor = {
		syntax = "auto",
		semantic_tokens = true,
		typing = false,
	},
	debugger = {
		enabled = "auto",
		console = "integratedTerminal",
	},
	ui = {
		locale = "en",
		log_level = "messages",
	},
})
