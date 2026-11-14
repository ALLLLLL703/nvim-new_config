---@type vim.lsp.Config
return {
	cmd = { "metals" },
	filetypes = { "scala", "sbt" },
	root_markers = {
		"build.sbt",
		"build.sc",
		"project.scala",
		".scala-build",
		".bsp",
		{ "build.gradle", "build.gradle.kts" },
		"pom.xml",
		".git",
	},
	capabilities = require("blink.cmp").get_lsp_capabilities({
		workspace = { configuration = false },
	}),
	init_options = {
		statusBarProvider = "show-message",
		isHttpEnabled = true,
		compilerOptions = { snippetAutoIndent = false },
	},
}
