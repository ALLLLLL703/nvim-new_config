vim.keymap.set("n", "<c-t>n", "<cmd>tabnext<cr>", { desc = "Go to next tab", silent = true })
vim.keymap.set("n", "<c-t>p", "<cmd>tabprevious<cr>", { desc = "Go to previous tab", silent = true })
vim.keymap.set("n", "<c-t>t", "<cmd>tabnew<cr>", { desc = "Create tab", silent = true })
vim.keymap.set("n", "<c-t>d", "<cmd>tabclose<cr>", { desc = "Close tab", silent = true })
