vim.keymap.set({ "n", "v" }, "<leader>ti", function()
	Snacks.toggle.inlay_hints()
end, { desc = "toggle inlay hint" })
