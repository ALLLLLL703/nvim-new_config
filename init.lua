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
local original_ui_open = vim.ui.open
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.open = function(path)
	vim.notify(path)
	if path:match("^jdt://") then
		vim.cmd("edit " .. vim.fn.fnameescape(path))

		return
	end
	original_ui_open(path)
end

Safe_Require("plugins")
Safe_Require("config")
Safe_Require("keymaps")
