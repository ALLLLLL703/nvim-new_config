vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.m",
	callback = function()
		vim.bo.filetype = "objc"
	end,
})
