local ufo = Safe_Require("ufo")

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require("ufo").setup({
	provider_selector = function(bufnr, filetype, buftype)
		return { "treesitter", "indent" }
	end,
	close_fold_kinds_for_ft = {
		default = { "imports", "comment" },
		java = { "import_declaration", "comment" },
		json = { "array" },
		rust = { "use_declaration" },
	},
	close_fold_current_line_for_ft = {
		default = true,
		c = false,
	},
})
