---@param arg_lead string
---@param _cmd_line string
---@param _cursor_pos integer
---@return string[]
local function complete_plugins_list(arg_lead, _cmd_line, _cursor_pos)
	local plugins = vim.pack.get()
	local names = {}
	for _, plugin in ipairs(plugins) do
		local name = plugin.spec.name
		if name:lower():find(arg_lead:lower(), 1, true) then
			table.insert(names, name)
		end
	end
	table.sort(names)
	return names
end
vim.api.nvim_create_user_command("PackUpdate", function(args)
	local targets = (#args.fargs > 0 and args.fargs) or nil
	local force = args.bang

	if targets then
		vim.notify("Checking updates for: " .. table.concat(targets, ", "), vim.log.levels.INFO)
	else
		vim.notify("Checking updates for all plugins", vim.log.levels.INFO)
	end
	vim.pack.update(targets, { force = force })
end, {
	nargs = "*",
	complete = complete_plugins_list,
	desc = "Update plugins (use ! to skip confirmation)",
	bang = true,
	force = true,
})

vim.api.nvim_create_user_command("PackStatus", function(args)
	local targets = #args.fargs > 0 and args.fargs or nil
	vim.pack.update(targets, { offline = true })
end, {
	nargs = "*",
	complete = complete_plugins_list,
	desc = "Check plugin status without fetching updates",
	force = true,
})
