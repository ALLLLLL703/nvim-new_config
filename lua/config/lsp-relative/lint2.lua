require("lint").linters_by_ft = {
	python = { "pyrefly", "pylint" },
}

local group = vim.api.nvim_create_augroup("config.lint", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
	group = group,
	pattern = "*.py",
	callback = function()
		-- try_lint without arguments runs the linters defined in `linters_by_ft`
		-- for the current filetype
		require("lint").try_lint()

		-- You can call `try_lint` with a linter name or a list of names to always
		-- run specific linters, independent of the `linters_by_ft` configuration
	end,
	desc = "Lint Python buffer after writing",
})
