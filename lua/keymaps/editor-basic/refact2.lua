local map = vim.keymap.set

map("v", "<leader>rf", "<cmd>Refactor extract_func<cr>", { desc = "refact func" })
map("v", "<leader>rF", "<cmd>Refactor extract_func_to_file<cr>", { desc = "refact func to file" })

map("v", "<leader>rv", "<cmd>Refactor extract_var<cr>", { desc = "refact var " })
