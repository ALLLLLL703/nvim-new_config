--- Agent Client Protocol providers.
---
--- pi is not an ACP agent itself: `pi --mode` only knows text/json/rpc. The `pi-acp` bridge
--- (npm, installed under ~/.local) speaks ACP over stdio and spawns `pi --mode rpc` behind it, so the
--- model, skills, MCP servers and AGENTS.md all still come from pi's own configuration.
local M = {}

---@return table<string, AvanteACPProvider>
function M.build()
	return {
		pi = {
			command = "pi-acp",
			args = {},
			-- HOME/PATH are passed explicitly: pi resolves `~/.pi/agent/auth.json` and its session
			-- directory through them.
			env = {
				NODE_NO_WARNINGS = "1",
				HOME = os.getenv("HOME"),
				PATH = os.getenv("PATH"),
			},
		},
	}
end

return M
