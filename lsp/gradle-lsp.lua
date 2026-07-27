local lspconfig = Safe_Require("lspconfig")
local blink = Safe_Require("blink.cmp")
---@type vim.lsp.Config
return {

	cmd = { "/home/sanae/.local/bin/gradle-lsp" },
	filetypes = { "groovy", "kotlin" },
	capabilities = blink and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities(),
	root_dir = function(bufnr, on_dir)
		local name = vim.api.nvim_buf_get_name(bufnr)
		local basename = vim.fs.basename(name)
		if not basename:match("%.gradle$") and not basename:match("%.gradle%.kts$") then
			return
		end
		local root = vim.fs.root(name, {
			"settings.gradle",
			"build.gradle",
			"build.gradle.kts",
			"settings.gradle.kts",
			"gradlew",
			".git",
		})
		if root then
			on_dir(root)
		end
	end,
}
