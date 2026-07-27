local bufferline = require("bufferline")
---@type bufferline.UserConfig
local opts = {
	options = {
		style_preset = bufferline.style_preset.default,
		themable = true,
		-- numbers = function(opts)
		-- 	return string.format("%s·%s", opts.raise(opts.id), opts.lower(opts.ordinal))
		-- end,
		middle_mouse_command = nil,
		diagnostics = "nvim_lsp",
		mode = "buffers",
		separator_style = "slope",
	},
}

require("bufferline").setup(opts)
