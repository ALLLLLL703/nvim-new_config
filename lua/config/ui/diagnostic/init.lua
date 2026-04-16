Safe_Require("config.ui.diagnostic.basic")

local signs = {

	[vim.diagnostic.severity.ERROR] = " ",
	[vim.diagnostic.severity.WARN] = " ",
	[vim.diagnostic.severity.INFO] = "󰙎",
	[vim.diagnostic.severity.HINT] = " ",
}
local hl_map = {
	[vim.diagnostic.severity.ERROR] = "ErrorMsg",
	[vim.diagnostic.severity.INFO] = "InfoMsg",
	[vim.diagnostic.severity.HINT] = "HintMsg",
	[vim.diagnostic.severity.WARN] = "WarnMsg",
}
vim.diagnostic.config({
	virtual_text = {
		prefix = "",
	},

	signs = {
		text = signs,
		linehl = hl_map,
	},

	underline = true,
	update_in_insert = false,
	severity_sort = true,
	status = {
		format = signs,
	},
})
