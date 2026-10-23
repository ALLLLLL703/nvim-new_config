local blink = require("blink.cmp")

---@type vim.lsp.Config
return {
	cmd = { "gradle-analyzer", "lsp" },
	filetypes = { "kotlin", "groovy" },
	capabilities = blink.get_lsp_capabilities(),
	root_dir = function(bufnr, on_dir)
		local name = vim.api.nvim_buf_get_name(bufnr)
		if name == "" then
			return
		end
		local root = vim.fs.root(name, {
			"settings.gradle",
			"settings.gradle.kts",
			"build.gradle",
			"build.gradle.kts",
			"gradlew",
			".git",
		}) or vim.fs.dirname(name)
		if root then
			on_dir(root)
		end
	end,
}
