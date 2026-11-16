local M = {}

function M.config_bookmarks()
	local std_config = vim.fn.stdpath("config")
	Snacks.picker.pick({})
end

return M
