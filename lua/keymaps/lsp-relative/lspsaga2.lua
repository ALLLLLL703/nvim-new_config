vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<cr>", { desc = "code action", silent = true })
vim.keymap.set("n", "<leader>cr", "<cmd>Lspsaga rename<cr>", { desc = "rename" })
vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga finder<cr>", { desc = "peek reference" })
vim.keymap.set("n", "<leader>ls", "<cmd>Lspsaga subtypes<cr>", { desc = "peek subtypes" })
vim.keymap.set("n", "<leader>ld", "<cmd>Lspsaga peek_definition<cr>", { desc = "peek defination" })
vim.keymap.set("n", "<leader>cs", "<cmd>Lspsaga outline<cr>", { desc = "outline" })
vim.keymap.set("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<cr>", { desc = "incoming_calls" })
vim.keymap.set("n", "<leader>co", "<cmd>Lspsaga outgoing_calls<cr>", { desc = "outgoing_calls" })
vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_buf_diagnostics<cr>", { desc = "show buf diagnostics" })
vim.keymap.set(
	"n",
	"<leader>cD",
	"<cmd>Lspsaga show_workspace_diagnostics<cr>",
	{ desc = "show workspace diagnostics" }
)
vim.keymap.set({ "n", "t" }, "<A-x>", "<cmd>Lspsaga term_toggle<cr>")
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>")
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		-- 针对当前 buffer 强制覆盖 K
		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", {
			buffer = args.buf,
			desc = "Lspsaga Hover (Forced)",
		})
	end,
})
