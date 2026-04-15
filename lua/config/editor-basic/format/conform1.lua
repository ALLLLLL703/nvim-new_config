local conform = Safe_Require("conform")
if not conform then
	return {}
end

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
	},
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		conform.format({
			async = false,
			bufnr = args.buf,
			timeout_ms = 1000,
			lsp_format = "fallback",
		})
	end,
})
