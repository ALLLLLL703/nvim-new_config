local M = {}

---@type NoiceFilter
local oxide_filter = {

	-- event = "msg_show",
	find = "^%s*Client md%-oxide quit with exit code 101%s*",
}

---@type NoiceRouteConfig[]
local previous = {
	{
		filter = { event = "notify", any = {
			{ find = "request handler panicked" },
		} },
		opts = { skip = true },
	},
	{
		filter = { event = "notify", any = {
			kind = "undo",
		} },
		opts = { skip = true },
	},
	{
		filter = {
			event = "msg_show",
			find = "^omnisharp%s*",
		},
		opts = { skip = true },
	},
	{
		filter = oxide_filter,
		opts = { skip = true },
	},
}

--- get the routes config by AL1033
---
---@return NoiceRouteConfig[]
function M.get_routes()
	---@type NoiceRouteConfig[]
	local full_routes = {}
	for i, v in ipairs(previous) do
		table.insert(full_routes, v)
		if DEBUG then
			vim.notify(
				string.format("inserted the %d element: %s", i, vim.inspect(v)),
				vim.log.levels.TRACE,
				{ icon = "🚩" }
			)
		end
	end

	return full_routes
end

return M
