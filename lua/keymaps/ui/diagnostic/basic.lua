local group = vim.api.nvim_create_augroup("config.diagnostic_keymaps", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args)
		vim.keymap.set({ "n", "v" }, "<leader>ti", function()
			Snacks.toggle.inlay_hints()
		end, { buffer = args.buf, desc = "Toggle inlay hints" })
	end,
	desc = "Set diagnostic keymaps on LSP attach",
})
