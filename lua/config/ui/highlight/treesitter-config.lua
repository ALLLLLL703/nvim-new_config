local group = vim.api.nvim_create_augroup("config.treesitter_highlight", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function()
		vim.treesitter.start()
	end,
	desc = "Start Tree-sitter highlighting",
})
