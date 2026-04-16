---@param module string
---@return unknown
function Safe_Require(module)
	local success, result = pcall(require, module)
	if not success then
		vim.notify("failed to load module " .. module .. "because of " .. result, vim.log.levels.ERROR)
		return nil
	end
	return result
end
if vim.g.vscode then
	return
end
Safe_Require("plugins")
Safe_Require("config")
Safe_Require("keymaps")
