--- System prompt additions for avante.
---
--- avante renders its own ReAct prompt and appends whatever this module returns,
--- so the text here only carries what avante cannot know: the rules pi reads
--- from its global `AGENTS.md`, and the MCP servers that are currently active.
local M = {}

local global_rules_path = vim.fs.joinpath(vim.fn.expand("~"), ".pi", "agent", "AGENTS.md")

--- The prompt is rebuilt for every message, so the rules file is read once and
--- invalidated by mtime instead of being re-read per request.
local rules_cache = { mtime = -1, text = "" }

---@return string
local function global_rules()
	local stat = vim.uv.fs_stat(global_rules_path)
	local mtime = stat and stat.mtime.sec or 0
	if mtime == rules_cache.mtime then
		return rules_cache.text
	end

	rules_cache.mtime = mtime
	rules_cache.text = ""

	if mtime > 0 then
		local read_ok, lines = pcall(vim.fn.readfile, global_rules_path)
		if read_ok then
			rules_cache.text = table.concat(lines, "\n")
		end
	end

	return rules_cache.text
end

--- MCPHub publishes the tools of started servers as prompt text. Stopped servers
--- stay hidden unless they are requested explicitly, which is what keeps a lazy
--- setup from advertising every tool of every server.
---@return string
local function active_servers_prompt()
	local loaded, message = pcall(function()
		local hub = require("mcphub").get_hub_instance()
		if not hub then
			return ""
		end
		-- `include_disabled` is the second argument: without it the model never
		-- learns which servers it could start through `toggle_mcp_server`.
		return hub:get_active_servers_prompt(true, true)
	end)

	if not loaded or type(message) ~= "string" then
		return ""
	end

	return message
end

--- Prompt appended to the avante request.
---@return string
function M.build()
	local sections = {}

	local rules = global_rules()
	if rules ~= "" then
		table.insert(sections, "## Global agent rules\n\n" .. rules)
	end

	local servers = active_servers_prompt()
	if servers ~= "" then
		table.insert(sections, servers)
	end

	return table.concat(sections, "\n\n")
end

return M
