local opt = {

	binary_path = vim.fn.exepath("dap-mcp-sidecar"),
	-- pi 的源码在 /usr/lib/node_modules 下，不在 workingDirectory 里
	allow_external_files = true,
}
require("dap-mcp").setup(opt)
