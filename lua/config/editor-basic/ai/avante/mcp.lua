--- MCP servers for avante, sourced from the pi catalog.
---
--- pi keeps its server catalog in `~/.config/mcp/mcp.json` while MCPHub reads
--- `~/.config/mcphub/servers.json`. Both describe the same servers in different
--- shapes, so the catalog stays in one place and is projected here at startup
--- instead of being maintained twice.
---
--- Setup requires the MCPHub binary on `PATH`:
---
--- ```sh
--- npm install -g --prefix ~/.local mcp-hub@latest
--- ```
---
--- The `--prefix` flag is required because the system npm prefix is root owned.
local M = {}

local source_path = vim.fs.joinpath(vim.fn.expand("~"), ".config", "mcp", "mcp.json")
local target_path = vim.fs.joinpath(vim.fn.expand("~"), ".config", "mcphub", "servers.json")

--- Fields MCPHub writes back into `servers.json` when the UI or the model
--- changes a server. They are carried over from the previous file so that
--- regenerating connection details does not reset runtime decisions:
--- `disabled` is the lazy-loading switch, so dropping it would start every
--- server on every reload.
local persisted_fields = {
	"disabled",
	"autoApprove",
	"disabled_tools",
	"disabled_resources",
	"custom_instructions",
}

--- Server descriptions reach the model through MCPHub's `use_mcp_tool` prompt,
--- which is how the model decides whether starting a stopped server is worth it.
local server_descriptions = {
	cratesio = "Search crates.io and read Rust crate metadata and documentation.",
	codegraph = "Query the code graph index of the current project.",
	["computer-use"] = "Control the desktop: mouse, keyboard, screenshots, window management. Starts on demand, slow.",
	context7 = "Fetch current library and framework API documentation from Context7.",
	dotnet = "Inspect .NET projects and solutions: MSBuild evaluation, packages, references.",
	github = "GitHub API: repositories, issues, pull requests, code search, actions. Needs GITHUB_PAT_TOKEN.",
	jd = "Query JD (京东) e-commerce data: products, prices, orders.",
	lsp = "Ask language servers directly: definitions, references, hover, symbols, diagnostics.",
	node_repl = "Run JavaScript in a persistent Node.js REPL with browser automation tooling.",
	["open-websearch"] = "Search the web and fetch page content.",
}

---@param path string
---@return table|nil
local function read_json(path)
	local read_ok, lines = pcall(vim.fn.readfile, path)
	if not read_ok or #lines == 0 then
		return nil
	end

	local decode_ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
	if not decode_ok or type(decoded) ~= "table" then
		return nil
	end

	return decoded
end

--- Converts one pi server entry into the MCPHub shape.
---
--- Entries with a `url` are streamable HTTP servers; the rest are stdio
--- commands. pi-only knobs (`lifecycle`, `requestTimeoutMs`, `auth`,
--- `startup_timeout_sec`, per-tool policies) have no MCPHub equivalent and are
--- dropped: timeouts are global in MCPHub and per-tool policy is handled by
--- `auto_approve`.
---@param entry table
---@return table
local function convert_connection(entry)
	if type(entry.url) == "string" then
		local converted = { type = "http", url = entry.url }
		local headers = vim.deepcopy(entry.headers or {})
		if entry.bearerTokenEnv and headers.Authorization == nil then
			headers.Authorization = "Bearer ${" .. entry.bearerTokenEnv .. "}"
		end
		if next(headers) ~= nil then
			converted.headers = headers
		end
		return converted
	end

	local converted = { command = entry.command }
	if entry.args then
		converted.args = entry.args
	end
	if entry.cwd then
		converted.cwd = entry.cwd
	end
	if entry.env then
		converted.env = entry.env
	end
	return converted
end

--- Builds the MCPHub configuration from the pi catalog.
---
--- Every server starts disabled so a fresh setup only pays for what the model
--- asks for; `persisted_fields` then restores whatever the previous file
--- recorded.
---@param source table
---@param existing table
---@return table
local function build_config(source, existing)
	local previous_servers = existing.mcpServers or {}
	local servers = {}

	-- pi stores the catalog under `mcpServers`; accept `servers` for hand-written
	-- catalogs.
	local catalog = source.mcpServers or source.servers or {}
	local names = vim.tbl_keys(catalog)
	table.sort(names)

	for _, name in ipairs(names) do
		local server = convert_connection(catalog[name])
		server.description = server_descriptions[name] or ("MCP server " .. name .. ".")

		local previous = previous_servers[name]
		if type(previous) == "table" then
			for _, field in ipairs(persisted_fields) do
				if previous[field] ~= nil then
					server[field] = previous[field]
				end
			end
		end

		if server.disabled == nil then
			server.disabled = true
		end

		servers[name] = server
	end

	return { mcpServers = servers }
end

--- Projects the pi catalog into `servers.json` when the two disagree.
---
--- The file is what MCPHub reloads, so it is only written on a real difference:
--- rewriting it on every start would reload every server each time. Output is
--- minified because this file is generated; edit `mcp.json` instead.
---@return boolean
function M.sync_servers()
	local source = read_json(source_path)
	local catalog = source and (source.mcpServers or source.servers)
	if type(catalog) ~= "table" then
		vim.notify(
			"avante/mcp: cannot read a server catalog from " .. source_path,
			vim.log.levels.WARN,
			{ title = "avante" }
		)
		return false
	end

	local existing = read_json(target_path) or {}
	local config = build_config(source, existing)
	if vim.deep_equal(config, existing) then
		return true
	end

	local encode_ok, encoded = pcall(vim.json.encode, config)
	if not encode_ok then
		vim.notify("avante/mcp: cannot encode " .. target_path, vim.log.levels.ERROR, { title = "avante" })
		return false
	end

	vim.fn.mkdir(vim.fs.dirname(target_path), "p")
	local write_ok = pcall(vim.fn.writefile, { encoded }, target_path)
	if not write_ok then
		vim.notify("avante/mcp: cannot write " .. target_path, vim.log.levels.ERROR, { title = "avante" })
		return false
	end

	return true
end

--- Starts MCPHub in lazy mode.
---
--- `auto_toggle_mcp_servers` is what makes servers lazy: the model only sees a
--- `use_mcp_tool` tool that starts one when it needs it, and `disabled` in
--- `servers.json` keeps the enabled set across restarts.
function M.setup()
	M.sync_servers()

	require("mcphub").setup({
		config = target_path,
		auto_approve = true,
		auto_toggle_mcp_servers = true,
		-- MCPHub exposes one request timeout for all servers, so it is sized for
		-- the slowest one: the `lsp` server waits on a cold language server.
		mcp_request_timeout = 180000,
	})
end

--- Avante custom tool exposing MCPHub to the model. Avante evaluates it per
--- request, so MCPHub is only required once a request is actually made.
---@return AvanteSlashCommand[]
function M.custom_tools()
	return { require("mcphub.extensions.avante").mcp_tool() }
end

return M
