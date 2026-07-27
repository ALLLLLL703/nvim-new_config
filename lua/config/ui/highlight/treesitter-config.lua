local group = vim.api.nvim_create_augroup("config.treesitter_highlight", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(args)
		local parser = vim.treesitter.get_parser(args.buf, nil, { error = false })
		if parser then
			vim.treesitter.start(args.buf)
		end
	end,
	desc = "Start Tree-sitter highlighting",
})
