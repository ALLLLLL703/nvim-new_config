vim.keymap.set("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Find buffers", silent = true })
vim.keymap.set("n", "<leader>ff", function()
	Snacks.picker.smart()
end, { desc = "Find files", silent = true })
vim.keymap.set("n", "<leader>fp", function()
	Snacks.picker.projects()
end, { desc = "Find projects", silent = true })
vim.keymap.set("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Find recent files", silent = true })
vim.keymap.set("n", "<leader>uC", function()
	Snacks.picker.colorschemes()
end, { desc = "Select colorscheme", silent = true })
vim.keymap.set("n", "<leader>hh", function()
	Snacks.picker.help()
end, { desc = "Search help", silent = true })
vim.keymap.set("n", "<leader>fg", function()
	Snacks.picker.grep()
end, { desc = "Grep files", silent = true })
vim.keymap.set("n", "<leader>sM", function()
	Snacks.picker.man()
end, { silent = true, desc = "Search man pages" })
vim.keymap.set("n", "<leader>lg", function()
	Snacks.lazygit()
end, { silent = true, desc = "Open Lazygit" })
vim.keymap.set("n", "<leader>ssi", function()
	Snacks.picker.icons()
end, { desc = "Search icons" })
vim.keymap.set("i", "<C-S-I>", function()
	Snacks.picker.icons()
end, { desc = "Search icons" })

vim.keymap.set("n", "<leader>ssk", function()
	Snacks.picker.keymaps()
end, { desc = "Search keymaps" })
vim.keymap.set("n", "<leader>ssh", function()
	Snacks.picker.highlights()
end, { desc = "Search highlight groups" })
vim.keymap.set({ "n", "t" }, "<c-/>", function()
	---@type snacks.terminal.Opts
	local opts = {}
	opts.win = { max_height = 25, position = "bottom", border = "rounded" }
	Snacks.terminal.toggle("zsh", opts)
end, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>nt", "<cmd>NoiceSnacks<cr>", { desc = "Show Noice messages", silent = true })

local group = vim.api.nvim_create_augroup("config.snacks_lsp_keymaps", { clear = true })

---@param bufnr integer
local function set_snacks_lsp_keymaps(bufnr)
	local function map(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
	end

	map("gd", Snacks.picker.lsp_definitions, "Go to definition")
	map("gD", Snacks.picker.lsp_declarations, "Go to declaration")
	map("gr", Snacks.picker.lsp_references, "Find references")
	map("<leader>fs", Snacks.picker.lsp_symbols, "Find document symbols")
	map("<leader>fw", Snacks.picker.lsp_workspace_symbols, "Find workspace symbols")
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args)
		set_snacks_lsp_keymaps(args.buf)
	end,
	desc = "Set Snacks LSP picker keymaps",
})
