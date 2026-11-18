-- From the repository root, run:
-- nvim -u NONE --noplugin -i NONE -n -S tests/repro/cmdpreview-nomodifiable.lua
-- Type `:Refactor ` with a trailing space and press Tab twice, without pressing Enter.
-- Affected builds abort with SIGABRT as soon as the second candidate is previewed.

vim.opt.inccommand = "nosplit"
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
vim.opt.wildoptions = "pum"

-- The buffer has to be displayed in a window, because command preview only checkpoints and
-- restores the buffers of existing windows.
local float_buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_open_win(float_buf, false, {
	relative = "editor",
	width = 20,
	height = 2,
	row = 1,
	col = 1,
	style = "minimal",
})

vim.api.nvim_create_user_command("Refactor", function() end, {
	desc = "Reproduce command preview rollback on a nonmodifiable buffer",
	nargs = 1,
	complete = function()
		return { "first", "last" }
	end,
	preview = function(args)
		if args.args ~= "last" then
			return 0
		end

		vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { "Preview text" })
		-- Any plugin that draws into its own scratch buffer and then locks it ends this way.
		vim.bo[float_buf].modifiable = false
		return 1
	end,
})
