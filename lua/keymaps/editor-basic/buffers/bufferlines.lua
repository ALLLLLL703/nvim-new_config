local map = vim.keymap.set
map({ "n", "v" }, "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers", silent = true })
map({ "n", "v" }, "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close buffers to the left", silent = true })
map({ "n", "v" }, "<leader>br", "<cmd>BufferLineCloseRight<CR>", { desc = "Close buffers to the right", silent = true })
map({ "n", "v" }, "<leader>bg", "<cmd>BufferLineGroupToggle<CR>", { desc = "Toggle buffer group", silent = true })
map({ "n", "v" }, "<leader>bs", "<cmd>BufferLinePick<CR>", { desc = "Select buffer", silent = true })
map({ "n", "v" }, "<leader>bS", "<cmd>BufferLinePickClose<CR>", { desc = "Select buffer to close", silent = true })
map({ "n", "v" }, "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Select next buffer", silent = true })
map({ "n", "v" }, "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Select previous buffer", silent = true })
