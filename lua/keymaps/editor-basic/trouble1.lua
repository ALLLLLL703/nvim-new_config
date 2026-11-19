local map = vim.keymap.set

map(
	"n",
	"<leader>xx",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ desc = "Toggle buffer diagnostics", silent = true }
)
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle all diagnostics", silent = true })
map("n", "<leader>xt", "<cmd>Trouble todo toggle filter.buf=0<cr>", { desc = "Toggle buffer TODOs", silent = true })
map("n", "<leader>xT", "<cmd>Trouble todo toggle<cr>", { desc = "Toggle all TODOs", silent = true })
