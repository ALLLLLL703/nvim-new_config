---@type LazySpec
return {
	-- Imports pull in every module under lua/plugins/, so a disabled plugin has to say so itself.
	-- coc.nvim competes with nvim-lspconfig for the same language servers.
	{ url = "https://github.com/neoclide/coc.nvim", enabled = false },
}
