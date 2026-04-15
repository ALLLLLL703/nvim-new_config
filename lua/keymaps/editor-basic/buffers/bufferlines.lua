local map = vim.keymap.set
map({ "n", "v" }, "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "delete others" })
map({ "n", "v" }, "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", { desc = "delete left" })
map({ "n", "v" }, "<leader>br", "<cmd>BufferLineCloseRight<CR>", { desc = "delete right" })
map({ "n", "v" }, "<leader>bg", "<cmd>BufferLineGroupToggle<CR>", { desc = "group init" })
map({ "n", "v" }, "<leader>bs", "<cmd>BufferLinePick<CR>", { desc = "buffer select" })
map({ "n", "v" }, "<leader>bS", "<cmd>BufferLinePickClose<CR>", { desc = "buffer select close" })
map({"n",'v'},'<Tab>','<cmd>BufferLineCycleNext<cr>',{desc = "buffer next",silent = true})
map({"n",'v'},'<S-Tab>','<cmd>BufferLineCyclePrev<cr>',{desc = "buffer next",silent = true})
