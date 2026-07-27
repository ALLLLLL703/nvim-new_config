local M = {}

---@class JdtlsAttachOptions
---@field gradle_wrapper? boolean

local root_markers = {
	"mvnw",
	"gradlew",
	".git",
	"pom.xml",
	"settings.gradle",
	"settings.gradle.kts",
	-- "build.gradle",
}

---@return string[]
local function get_bundles()
	local mason_path = vim.fn.stdpath("data") .. "/mason"
	local java_debug_path = mason_path .. "/packages/java-debug-adapter"
	local java_test_path = mason_path .. "/packages/java-test"
	local bundles = {}

	vim.list_extend(
		bundles,
		vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
	)
	vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n"))

	return bundles
end

---Start or attach JDTLS for the current Java project.
---@param opts? JdtlsAttachOptions
function M.attach(opts)
	opts = opts or {}

	local jdtls = require("jdtls")
	local root_dir = jdtls.setup.find_root(root_markers)
	if not root_dir then
		return
	end

	local lombok_path = "/home/sanae/.m2/repository/org/projectlombok/lombok/1.18.34/lombok-1.18.34.jar"
	local jdtls_launcher = vim.fn.glob("/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
	local workspace_dir = root_dir .. "/.jdtls"
	local gradle_settings = { downloadSources = true }
	if opts.gradle_wrapper then
		gradle_settings.wrapper = { enabled = true }
	end

	---@type vim.lsp.ClientConfig
	local jdtls_config = {
		cmd = {
			"java",
			"-javaagent:" .. lombok_path,
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xms1g",
			"-jar",
			jdtls_launcher,
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",
			"-configuration",
			"/usr/share/java/jdtls/config_linux",
			"-data",
			"/home/sanae/.local/share/jdtls/workspace" .. workspace_dir,
		},
		root_dir = root_dir,
		---@type lspconfig.settings.jdtls
		settings = {
			java = {
				eclipse = { downloadSources = true },
				maven = { downloadSources = true },
				gradle = gradle_settings,
				configuration = {
					updateBuildConfiguration = "interactive",
				},
				compile = {
					nullAnalysis = {
						mode = "automatic",
					},
				},
			},
		},
		init_options = {
			bundles = get_bundles(),
		},
	}

	jdtls.start_or_attach(jdtls_config)
	jdtls.setup_dap({ hotcodereplace = "auto", config_overrides = {} })
end

return M
