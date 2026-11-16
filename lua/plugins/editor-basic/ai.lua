---@type LazySpec
local plugins = {
	{
		url = "https://github.com/yetone/avante.nvim",
		-- avante renders its prompts through Rust libraries that only its build script puts in
		-- place. A plain git checkout leaves the sidebar raising "missing avante_templates" on
		-- every keystroke, so the build runs on install and on update. This mirrors `:AvanteBuild`:
		-- build.sh needs the version as an argument, which avante keeps in lua/avante/version.lua.
		build = function(plugin)
			local declared = vim.fn.readfile(plugin.dir .. "/lua/avante/version.lua")[1] or ""
			local version = declared:match('"([^"]+)"')

			if not version then
				vim.notify("avante.nvim: cannot read its version file", vim.log.levels.ERROR)
				return
			end

			local out = vim.system({ "bash", "build.sh", version }, { cwd = plugin.dir, text = true }):wait()

			if out.code ~= 0 then
				vim.notify(
					"avante.nvim build failed: " .. (out.stderr ~= "" and out.stderr or out.stdout),
					vim.log.levels.ERROR
				)
			end
		end,
	},
	{ url = "https://github.com/echasnovski/mini.pick" },
	{ url = "https://github.com/zbirenbaum/copilot.lua" },
	{ url = "https://github.com/hakonharnes/img-clip.nvim" },
	{ url = "https://github.com/johnseth97/codex.nvim" },
	{ url = "https://github.com/milanglacier/minuet-ai.nvim" },
	{ url = "https://github.com/sudo-tee/opencode.nvim" },
	{ url = "https://github.com/ravitemer/mcphub.nvim" },
	{ url = "https://github.com/ColinKennedy/mega.cmdparse" },
	{ url = "https://github.com/ColinKennedy/mega.logging" },
	--[[ 	{ url = "https://github.com/opilotlsp-nvim/copilot-lsp" }, ]]
}

return plugins
