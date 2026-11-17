vim.keymap.set("n", "<leader>fC", function()
	require("config.editor-basic.picker.custom.usually-config").config_bookmarks()
end, { desc = "Find config files", silent = true })
