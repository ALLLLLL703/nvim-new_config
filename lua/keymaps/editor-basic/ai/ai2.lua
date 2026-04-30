local map = vim.keymap.set

map("n", "<leader>a?", "<cmd>AvanteModels<cr>", { desc = "select models" })

map("n", "<leader>ae", "<cmd>AvanteEdit<cr>", { desc = "edit code blocks" })
map("v", "<leader>ae", "<cmd>'<,'>AvanteEdit<cr>", { desc = "edit code blocks" })
map("n", "<leader>aS", "<cmd>AvanteStop<cr>", { desc = "stop current request" })
map("n", "<leader>ah", "<cmd>AvanteHistory<cr>", { desc = "chat history" })
map("n", "<leader>ad", "<cmd>AvanteShowRepoMap<cr>", { desc = "repo map" })
map("n", "<leader>aa", "<cmd>AvanteToggle<cr>", { desc = "show side bar" })
map("n", "<leader>ar", "<cmd>AvanteRefresh<cr>", { desc = "refresh side bar" })
map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "claude code toggle" })
