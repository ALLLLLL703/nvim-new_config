--- Resolves API credentials for avante providers.
---
--- pi stores API keys in `~/.pi/agent/auth.json`. The same store is reused here
--- so both agents read one source of truth. Environment variables still win so
--- a temporary override never requires editing config files.
local M = {}

---@class AvanteCredential
---@field api_key string
---@field source "env"|"auth_json"

local auth_store = vim.fs.joinpath(vim.fn.expand("~"), ".pi", "agent", "auth.json")

---@param name string
---@return string|nil
local function read_auth_store(name)
	local ok, lines = pcall(vim.fn.readfile, auth_store)
	if not ok or #lines == 0 then
		return nil
	end

	local decoded_ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
	if not decoded_ok or type(decoded) ~= "table" then
		return nil
	end

	local entry = decoded[name]
	if type(entry) ~= "table" or entry.type ~= "api_key" then
		return nil
	end

	local key = entry.key
	if type(key) ~= "string" or key == "" then
		return nil
	end

	return key
end

---@param name string Auth store field, e.g. "deepseek".
---@param env_name string Environment variable consulted first.
---@return AvanteCredential|nil
function M.resolve(name, env_name)
	local from_env = vim.env[env_name]
	if from_env and from_env ~= "" then
		return { api_key = from_env, source = "env" }
	end

	local from_store = read_auth_store(name)
	if from_store then
		return { api_key = from_store, source = "auth_json" }
	end

	return nil
end

return M
