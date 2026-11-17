DEBUG = false

if vim.fn.getenv("NVIM_DEBUG") ~= vim.NIL then
	DEBUG = true
	vim.notify("AL1033 Debug mode enable")
end
require("config.ui")
require("config.editor-basic")
require("config.lsp-relative")
require("config.builtin")
require("config.git")
vim.cmd("colorscheme catppuccin-mocha")
