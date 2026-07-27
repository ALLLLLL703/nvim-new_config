vim.keymap.set({ "n", "t" }, "<A-x>", "<cmd>Lspsaga term_toggle<cr>", {
	desc = "Toggle terminal",
	silent = true,
})

local group = vim.api.nvim_create_augroup("config.lspsaga_keymaps", { clear = true })

---@param bufnr integer
local function set_lspsaga_keymaps(bufnr)
	local function map(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
	end

	map("<leader>ca", "<cmd>Lspsaga code_action<cr>", "Show code actions")
	map("<leader>cr", "<cmd>Lspsaga rename<cr>", "Rename symbol")
	map("<leader>lr", "<cmd>Lspsaga finder<cr>", "Find definitions and references")
	map("<leader>ls", "<cmd>Lspsaga subtypes<cr>", "Show subtypes")
	map("<leader>ld", "<cmd>Lspsaga peek_definition<cr>", "Peek definition")
	map("<leader>cs", "<cmd>Lspsaga outline<cr>", "Show symbol outline")
	map("<leader>ci", "<cmd>Lspsaga incoming_calls<cr>", "Show incoming calls")
	map("<leader>co", "<cmd>Lspsaga outgoing_calls<cr>", "Show outgoing calls")
	map("<leader>cd", "<cmd>Lspsaga show_buf_diagnostics<cr>", "Show buffer diagnostics")
	map("<leader>cD", "<cmd>Lspsaga show_workspace_diagnostics<cr>", "Show workspace diagnostics")
	map("K", "<cmd>Lspsaga hover_doc<cr>", "Show hover documentation")
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args)
		set_lspsaga_keymaps(args.buf)
	end,
	desc = "Set Lspsaga keymaps on LSP attach",
})
