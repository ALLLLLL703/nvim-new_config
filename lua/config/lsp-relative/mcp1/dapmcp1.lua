local opt = {

	binary_path = vim.fn.exepath("dap-mcp-sidecar"),
	-- pi 的源码在 /usr/lib/node_modules 下，不在 workingDirectory 里
	allow_external_files = true,
}

-- dap-mcp is not declared in the plugin specs, so it is an optional integration here. Requiring it
-- directly aborts the whole `config` chain when it is absent, which also skips options, git signs
-- and the colorscheme, so the failure is reported and skipped instead.
local loaded, dap_mcp = pcall(require, "dap-mcp")

if not loaded then
	-- Deferred so the warning lands after startup finishes; echoing it while the editor is still
	-- coming up leaves the user on a hit-enter prompt.
	vim.schedule(function()
		vim.notify(
			"dap-mcp is not installed, skipping its setup. Install the plugin and restart to enable it.",
			vim.log.levels.WARN,
			{ title = "config.lsp-relative.mcp1" }
		)
	end)
	return
end

dap_mcp.setup(opt)
