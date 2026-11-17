require("transparent").setup({
	-- table|function: default groups
	groups = {
		"Normal",
		"NormalNC",
		"Comment",
		"Constant",
		"Special",
		"Identifier",
		"Statement",
		"PreProc",
		"Type",
		"Underlined",
		"Todo",
		"String",
		"Function",
		"Conditional",
		"Repeat",
		"Operator",
		"Structure",
		"LineNr",
		"NonText",
		"SignColumn",
		"CursorLine",
		"CursorLineNr",
		"StatusLine",
		"StatusLineNC",
		"EndOfBuffer",
		"SnacksPicker",
		-- The tabline row is painted by these before any plugin group applies, so leaving them
		-- opaque makes the whole bar look solid even when every `BufferLine*` group is cleared.
		"TabLine",
		"TabLineFill",
		"TabLineSel",
		"WinBar",
		"WinBarNC",
	},
	-- table|function: additional groups that should be cleared
	-- bufferline has 60+ groups and derives their backgrounds from the basic groups, so resolve
	-- them by prefix instead of listing the four that happened to be in use.
	extra_groups = function()
		return vim.fn.getcompletion("BufferLine", "highlight")
	end,
	-- table|function: groups you don't want to clear
	exclude_groups = {},
	-- function: code to be executed after highlight groups are cleared
	-- Also the user event "TransparentClear" will be triggered
	on_clear = function() end,
})

-- `setup()` only stores the config. The clearing itself is gated on this flag, which otherwise has
-- to be set by `:TransparentEnable` and cached in `stdpath("data")/transparent_cache`, so without
-- this line transparency silently does nothing on a fresh profile.
vim.g.transparent_enabled = true
