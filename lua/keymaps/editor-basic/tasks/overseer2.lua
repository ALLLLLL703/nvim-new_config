local map = vim.keymap.set

map("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Toggle Overseer", silent = true })
map("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "Run Overseer task", silent = true })
