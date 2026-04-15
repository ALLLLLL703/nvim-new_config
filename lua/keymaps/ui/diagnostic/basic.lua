vim.keymap.set({ "n", "v" }, "<leader>ti", function()
	local enabled = vim.lsp.inlay_hint.is_enabled()
	vim.lsp.inlay_hint.enable(not enabled)
end, { desc = "toggle inlay hint" })
