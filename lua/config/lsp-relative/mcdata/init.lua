local group = vim.api.nvim_create_augroup("config.mcfunction_filetype", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	pattern = "*.mcfunction",
	callback = function()
		vim.bo.filetype = "mcfunction"
	end,
	desc = "Set mcfunction filetype",
})
