local opt = {

	binary_path = vim.fn.exepath("dap-mcp-sidecar"),
}
require("dap-mcp").setup(opt)
