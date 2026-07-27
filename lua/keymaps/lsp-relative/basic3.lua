local map = vim.keymap.set

map("n", "gD", Snacks.picker.lsp_type_definitions, { desc = "goto type defination", silent = true })
map("n", "gi", Snacks.picker.lsp_implementations, { desc = "goto impl" })
