---@brief
---Pre-alpha official Kotlin support for Visual Studio Code and an implementation of Language Server Protocol for the Kotlin language.
---
---The server is based on IntelliJ IDEA and the IntelliJ IDEA Kotlin Plugin implementation.

--- The presence of one of these files indicates a project root directory
--
--  These are configuration files for the various build systems supported by
--  Kotlin.

---@type vim.lsp.Config
return {
	filetypes = { "kotlin" },
	cmd = {
		"/home/sanae/.local/share/zed/extensions/work/kotlin/kotlin-lsp-262.7569.0/kotlin-server-262.7569.0/bin/intellij-server",
		"--stdio",
	},
	cmd_env = {
		JAVA_HOME = "/usr/lib/jvm/java-21-openjdk",
		-- PATH = "/usr/lib/jvm/java-21-openjdk/bin:" .. (vim.env.PATH or ""),
	},
	root_markers = {
		"settings.gradle", -- Gradle (multi-project)
		"settings.gradle.kts", -- Gradle (multi-project)
		"pom.xml", -- Maven
		"build.gradle", -- Gradle
		"build.gradle.kts", -- Gradle
		"workspace.json", -- Used to integrate your own build system
	},
}
