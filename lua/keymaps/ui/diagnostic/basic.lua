vim.keymap.set({ "n", "v" }, "<leader>ti", function()
	vim.lsp.inlay_hint.is_enabled()
end)
