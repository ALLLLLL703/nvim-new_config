---@param module string
---@return unknown
local function safe_require(module)
	local success, result = pcall(require, module)
	if not success then
		vim.notify("Failed to load module " .. module .. ": " .. result, vim.log.levels.ERROR)
		return nil
	end
	return result
end
if vim.g.vscode then
	return
end

safe_require("config.rocks")
safe_require("plugins")
safe_require("config")
safe_require("keymaps")
