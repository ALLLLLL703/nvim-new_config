---@type vim.lsp.Config
local config = {
	cmd = { vim.fn.expand("~/.local/bin/cmake-analyzer"), "--stdio" },
	filetypes = { "cmake" },
	root_dir = function(bufnr, on_dir)
		local root = vim.fs.root(bufnr, { "CMakeLists.txt" })
		local directory = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:h")
		on_dir(root or directory)
	end,
}

return config
