local map = vim.keymap.set

map("n", "<leader>tw", function()
	if vim.o.wrap then
		vim.cmd("set nowrap")
		vim.notify("Wrap disable")
	else
		vim.cmd("set wrap")
		vim.notify("Wrap enable")
	end
end, { desc = "Toggle line wrapping" })
