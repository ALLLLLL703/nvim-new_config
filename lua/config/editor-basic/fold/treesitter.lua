local group = vim.api.nvim_create_augroup("config.treesitter_folds", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function()
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
	end,
	desc = "Enable Tree-sitter folds",
})
