local group = vim.api.nvim_create_augroup("config.lsp_keymaps", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args)
		vim.keymap.set("n", "gy", Snacks.picker.lsp_type_definitions, {
			buffer = args.buf,
			desc = "Go to type definition",
			silent = true,
		})
		vim.keymap.set("n", "gi", Snacks.picker.lsp_implementations, {
			buffer = args.buf,
			desc = "Go to implementation",
			silent = true,
		})
	end,
	desc = "Set LSP navigation keymaps",
})
