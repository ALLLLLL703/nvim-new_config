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
require("neo-tree").setup(M)
