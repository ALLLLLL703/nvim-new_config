---@type LazySpec
local M = {
	-- Snapshot commands are the only entry points; nothing requires the module at startup.
	{
		url = "https://github.com/mistricky/codesnap.nvim",
		cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapASCII" },
	},
}

return M
