---@type neotree.Config
local M = {
	window = {
		mappings = {
			["P"] = {
				"toggle_preview",
				config = {
					use_float = false,
					use_snacks_image = true,
					use_image_nvim = true,
				},
			},
			["l"] = "focus_preview",
			["<C-d>"] = { "scroll_preview", config = { direction = 10 } },
			["<C-u>"] = { "scroll_preview", config = { direction = -10 } },
		},
	},
}
local function on_move(data)
	Snacks.rename.on_rename_file(data.source, data.destination)
end
local events = require("neo-tree.events")
M.event_handlers = M.event_handlers or {}
vim.list_extend(M.event_handlers, {
	{ event = events.FILE_MOVED, handler = on_move },
	{ event = events.FILE_RENAMED, handler = on_move },
})
require("neo-tree").setup(M)
