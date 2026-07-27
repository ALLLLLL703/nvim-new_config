local map = vim.keymap.set

map({ "n", "v" }, "<leader>ng", "<cmd>Neogen<cr>", { desc = "Generate documentation", silent = true })
