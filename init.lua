---@param module string
---@return unknown
function safe_require(module)
	local success, result = pcall(require, module)
	if not success then
		vim.notify("Failed to load module " .. module .. ": " .. result, vim.log.levels.ERROR)
		return nil
	end
	return result
end
if vim.g.vscode then
	return
end

safe_require("config.rocks")

-- lazy.nvim installs and loads every plugin. The bootstrap is what keeps a machine working after
-- `rm -rf ~/.local/share/nvim`, so it has to run before anything requires a plugin.
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

---@class PluginModule
---@field modname string
---@field path string

--- Collects every spec module below a directory, including nested ones.
---@param dir string Directory to walk.
---@param module string Module prefix for the files in `dir`.
---@param acc PluginModule[] Collects the results.
local function collect_modules(dir, module, acc)
	for name, kind in vim.fs.dir(dir) do
		local path = vim.fs.joinpath(dir, name)

		if kind == "directory" then
			collect_modules(path, module .. "." .. name, acc)
		elseif kind == "file" and name:sub(-4) == ".lua" then
			acc[#acc + 1] = { modname = module .. "." .. name:sub(1, -5), path = path }
		end
	end
end

--- Reads every spec module below lua/plugins.
---
--- lazy's own `{ import = "plugins" }` only looks one level deep and skips a directory unless it
--- holds an `init.lua` (`lazy/core/util.lua` `lsmod`), which misses `lua/plugins/editor-basic/*.lua`
--- and friends. Walking the tree keeps the per-capability layout and still needs one entry only.
---@return LazySpec[]
local function import_plugins()
	local modules = {}
	collect_modules(vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "plugins"), "plugins", modules)

	table.sort(modules, function(a, b)
		return a.modname < b.modname
	end)

	local specs = {}
	for _, entry in ipairs(modules) do
		vim.list_extend(specs, require(entry.modname))
	end

	return specs
end

-- Adding a plugin means adding a file below lua/plugins. Modules load in alphabetical order; the
-- specs that have to win their conflicts set `priority`.
require("lazy").setup({
	{ name = "plugins", import = import_plugins },
}, {
	lockfile = vim.fs.joinpath(vim.fn.stdpath("config"), "lazy-lock.json"),
	checker = { enabled = false },
	change_detection = { notify = false },
})

safe_require("config.native")
safe_require("config")
safe_require("keymaps")
