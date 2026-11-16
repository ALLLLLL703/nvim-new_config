-- lazy.nvim owns plugin installation. The module list and the spec files keep the
-- same layout they had under vim.pack.
local lazypath = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim")

if not vim.uv.fs_stat(lazypath) then
	local clone = vim.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	}, { text = true }):wait()

	if clone.code ~= 0 then
		vim.notify(
			"Failed to install lazy.nvim: " .. (clone.stderr or "unknown error"),
			vim.log.levels.ERROR,
			{ title = "lazy.nvim" }
		)
		return
	end
end

vim.opt.rtp:prepend(lazypath)

local plugin_modules = {
	"plugins.base",
	"plugins.ui.bufferline-plugins",
	"plugins.ui.whichkey",
	"plugins.editor-basic.format",
	"plugins.lsp-relative.snippets.Luasnip",
	"plugins.lsp-relative.snippets.friendly-snippet",
	"plugins.ui.lspsaga3",
	"plugins.editor-basic.snacks1",
	"plugins.ui.icon",
	"plugins.editor-basic.neotree1",
	"plugins.ui.dap1",
	"plugins.lsp-relative.mason1",
	"plugins.ui.opacity1",
	"plugins.lsp-relative.schemas.schemasstore1",
	"plugins.ui.noice1",
	"plugins.lsp-relative.jdtls",
	-- "plugins.lsp-relative.coc",
	"plugins.lsp-relative.ufo1",
	"plugins.ui.image1",
	"plugins.ui.markdown",
	"plugins.ui.alpha1",
	"plugins.lsp-relative.rust1",
	"plugins.ui.rainbow-delimiters1",
	"plugins.editor-basic.ai",
	"plugins.ui.lualine1",
	"plugins.lsp-relative.omnisharp1",
	"plugins.lsp-relative.lspconfig1",
	"plugins.editor-basic.telescope1",
	"plugins.editor-basic.oil1",
	"plugins.ui.undo",
	"plugins.ui.colorful-menu1",
	"plugins.lsp-relative.csharp2",
	"plugins.ui.cluade1",
	-- "plugins.minecraft-dev1",
	"plugins.editor-basic.comment1",
	"plugins.editor-basic.textobject1",
	"plugins.editor-basic.refact1",
	"plugins.ui.colorizer1",
	"plugins.editor-basic.tasks1",
	"plugins.ui.discord1",
	"plugins.editor-basic.remote",
	"plugins.editor-basic.doc1",
	"plugins.editor-basic.nvim-mcp1",
	"plugins.lsp-relative.lint1",
	"plugins.lsp-relative.kotlin1",
	"plugins.ui.theme1",
	"plugins.ui.snap",
}

local specs = {}
for _, module in ipairs(plugin_modules) do
	vim.list_extend(specs, require(module))
end

require("lazy").setup(specs, {
	-- Keep the lockfile next to the configuration so it is version controlled with it.
	lockfile = vim.fs.joinpath(vim.fn.stdpath("config"), "lazy-lock.json"),
	checker = { enabled = false },
	change_detection = { notify = false },
})

require("plugins.native")
