local M = {
	{
		src = "https://github.com/mrcjkb/rustaceanvim",
		-- To avoid being surprised by breaking changes,
		-- I recommend you set a version range
		version = vim.version.range("^9"),
	},
	{

		src = "https://github.com/saecki/crates.nvim",
	},
}
return M
