local map = vim.keymap.set

map("v", "<leader>rf", "<cmd>Refactor extract_func<cr>", { desc = "Extract function", silent = true })
map("v", "<leader>rF", "<cmd>Refactor extract_func_to_file<cr>", { desc = "Extract function to file", silent = true })

map("v", "<leader>rv", "<cmd>Refactor extract_var<cr>", { desc = "Extract variable", silent = true })
