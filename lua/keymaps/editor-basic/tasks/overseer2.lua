local map = vim.keymap.set

map("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "toggle overseer" })
map("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "overseer run" })
