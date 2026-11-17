local M = {}

--- Frequently edited config files. Paths without a `~` are resolved against `stdpath("config")`.
---@type { file: string, desc: string }[]
local bookmarks = {
	{ file = "init.lua", desc = "entry point / lazy bootstrap" },
	{ file = "AGENTS.md", desc = "config instructions" },
	{ file = "agent-instructions/STYLE.md", desc = "style rules" },
	{ file = ".luarc.jsonc", desc = "lua_ls workspace" },
	{ file = "lua/config/init.lua", desc = "config load chain" },
	{ file = "lua/config/native.lua", desc = "extra runtimepath" },
	{ file = "lua/config/editor-basic/init.lua", desc = "editor chain" },
	{ file = "lua/config/editor-basic/comment2.lua", desc = "Comment.nvim patch" },
	{ file = "lua/config/editor-basic/picker/snacks2.lua", desc = "snacks setup" },
	{ file = "lua/config/editor-basic/picker/custom/usually-config.lua", desc = "this picker" },
	{ file = "lua/config/editor-basic/ai/avante/init.lua", desc = "avante" },
	{ file = "lua/config/editor-basic/ai/avante/credentials.lua", desc = "avante keys" },
	{ file = "lua/config/ui/notify1/noice2.lua", desc = "noice setup" },
	{ file = "lua/config/ui/notify1/routes.lua", desc = "noice routes" },
	{ file = "lua/config/lsp-relative/enable.lua", desc = "enabled LSP servers" },
	{ file = "lua/keymaps/init.lua", desc = "leader + keymaps" },
	{ file = "lua/plugins/base.lua", desc = "base plugin specs" },
	{ file = "after/lsp/metals.lua", desc = "metals overrides" },
	{ file = "ftplugin/java.lua", desc = "java filetype" },
	{ file = "lazy-lock.json", desc = "plugin lockfile" },
	{ file = "~/.pi/agent/AGENTS.md", desc = "global agent rules" },
	{ file = "~/.config/mcp/mcp.json", desc = "MCP servers (source)" },
	{ file = "~/.config/mcphub/servers.json", desc = "MCPHub (generated)" },
}

--- Resolves a bookmark to an absolute path.
---@param file string Entry from `bookmarks`.
---@return string? path Absolute path, or nil when the file is gone.
local function resolve(file)
	local path = file:sub(1, 1) == "~" and vim.fs.normalize(file) or vim.fs.joinpath(vim.fn.stdpath("config"), file)

	if not vim.uv.fs_stat(path) then
		return nil
	end

	return path
end

--- Opens a picker with the config files listed in `bookmarks`. Stale entries are dropped so a moved
--- file never breaks the picker.
function M.config_bookmarks()
	local items = {}
	local missing = {}

	for _, entry in ipairs(bookmarks) do
		local path = resolve(entry.file)

		if path then
			items[#items + 1] = { file = path, text = entry.file, desc = entry.desc }
		else
			missing[#missing + 1] = entry.file
		end
	end

	if #missing > 0 then
		vim.schedule(function()
			vim.notify(
				"config bookmarks: missing " .. table.concat(missing, ", "),
				vim.log.levels.WARN,
				{ title = "usually-config" }
			)
		end)
	end

	if #items == 0 then
		vim.notify("config bookmarks: nothing to open", vim.log.levels.WARN, { title = "usually-config" })
		return
	end

	Snacks.picker.pick({
		title = "Config bookmarks",
		items = items,
		format = function(item)
			local icon, icon_hl = Snacks.util.icon(item.file, "file")

			return {
				{ icon, icon_hl },
				{ " " .. item.text, "Title" },
				{ "  " .. item.desc, "Comment" },
			}
		end,
		preview = "file",
		confirm = "edit",
	})
end

return M
