---@type vim.pack.Spec[]
local plugins = {
	{ src = "https://github.com/yetone/avante.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
	{ src = "https://github.com/hakonharnes/img-clip.nvim" },
	{ src = "https://github.com/johnseth97/codex.nvim" },
	{ src = "https://github.com/milanglacier/minuet-ai.nvim" },
	{ src = "https://github.com/sudo-tee/opencode.nvim" },
	{ src = "https://github.com/ravitemer/mcphub.nvim" },
	{ src = "https://github.com/ColinKennedy/mega.cmdparse" },
	{ src = "https://github.com/ColinKennedy/mega.logging" },
	--[[ 	{ src = "https://github.com/opilotlsp-nvim/copilot-lsp" }, ]]
}

-- avante renders its prompts through Rust libraries that only its build script puts in place. A
-- plain git checkout leaves the sidebar raising "missing avante_templates" on every keystroke.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name ~= "avante.nvim" then
			return
		end
		if ev.data.kind ~= "install" and ev.data.kind ~= "update" then
			return
		end
		vim.system({ "bash", "build.sh" }, { cwd = ev.data.path }):wait()
	end,
})

return plugins
