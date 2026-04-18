---@param Arglead string
---@param Cmdline string
---@param CursurPos number
---@return string[]
local function complete_plugins_list(Arglead, Cmdline, CursurPos)
	local plugins = vim.pack.get()
	local names = {}
	for _, p in ipairs(plugins) do
		local name = p.spec.name
		if name:lower():find(Arglead:lower(), 1, true) then
			table.insert(names, name)
		end
	end
	table.sort(names)
	return names
end
vim.api.nvim_create_user_command(
	"PackUpdate",
	function(args)
		local targets = (#args.fargs > 0 and args.fargs) or nil
		local force = args.bang

		if targets then
			vim.notify("Checking updates for: " .. table.concat(targets, ", "), vim.log.levels.INFO)
		else
			vim.notify("Checking updates for all plugins", vim.log.levels.INFO)
		end
		vim.pack.update(targets, { force = force })
	end,
	{ nargs = "*", complete = complete_plugins_list, desc = "Update plugins (use ! to skip confirmation)", bang = true }
)

vim.api.nvim_create_user_command("PackStatus", function(args)
	local targets = #args.fargs > 0 and args.fargs or nil
	vim.pack.update(targets, { offline = true })
end, {
	nargs = "*",
	complete = complete_plugins_list,
	desc = "checking plugin status without pull new:)",
})
