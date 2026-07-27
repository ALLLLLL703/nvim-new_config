vim.keymap.set("n", "-", function()
	require("oil").open()
end, { desc = "toggle oil" })
