vim.o.wrap = false

-- Preview the current buffer in a browser. markdown-preview.nvim is loaded by the `ft` trigger
-- above, so the command exists by the time this buffer is interactive.
vim.keymap.set("n", "<leader>up", "<cmd>MarkdownPreviewToggle<cr>", {
	buffer = true,
	desc = "Toggle markdown preview",
	silent = true,
})
