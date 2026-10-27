---@module 'avante'
---@type avante.Config
local opts = {
	provider = "deepseek",
	behaviour = {
		auto_suggestions = false,
	},
	mappings = {
		suggestion = {
			accept = "<A-CR>",
		},
	},
	providers = require("config.editor-basic.ai.avante.providers").build(),
}

require("avante").setup(opts)
