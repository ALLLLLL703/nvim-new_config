local group = vim.api.nvim_create_augroup("config.objc_filetype", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	pattern = "*.m",
	callback = function()
		vim.bo.filetype = "objc"
	end,
	desc = "Set Objective-C filetype",
})
