local Mcp = require("config.editor-basic.ai.avante.mcp")
local Prompts = require("config.editor-basic.ai.avante.prompts")

-- MCPHub has to be running before the first request, because the system prompt
-- only lists servers it already knows about.
Mcp.setup()

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
	-- Tool calls run without confirmation prompts, matching the pi setup this
	-- configuration is ported from.
	auto_approve_tool_permissions = true,
	system_prompt = Prompts.build,
	custom_tools = Mcp.custom_tools,
}

require("avante").setup(opts)
