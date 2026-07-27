vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.mcfunction",
	callback = function()
		vim.bo.filetype = "mcfunction"
	end,
})
