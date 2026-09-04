local blink = require("blink.cmp")

---@type vim.lsp.Config
return {
	cmd = { "gradle-lsp", "--stdio" },
	filetypes = { "kotlin" },
	capabilities = blink and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities(),
	root_dir = function(bufnr, on_dir)
		local name = vim.api.nvim_buf_get_name(bufnr)
		local basename = vim.fs.basename(name)
		if not basename:match("%.gradle%.kts$") then
			return
		end
		local root = vim.fs.root(name, {
			"settings.gradle",
			"settings.gradle.kts",
			"gradlew",
			".git",
		}) or vim.fs.dirname(name)
		on_dir(root)
	end,
}
