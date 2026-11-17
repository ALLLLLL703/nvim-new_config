local M = {}

--- Config files worth reopening often, wherever they live on this machine. Every entry is an
--- absolute path or starts with `~`, so the picker behaves the same from any working directory.
---@type { file: string, desc: string }[]
local bookmarks = {
	{ file = "~/.config/nvim/init.lua", desc = "neovim entry point" },
	{ file = "~/.bashrc", desc = "bash" },
	{ file = "~/.zshenv", desc = "zsh environment" },
	{ file = "~/.zshrc", desc = "zsh" },
	{ file = "~/.profile", desc = "login shell profile" },
	{ file = "~/.gitconfig", desc = "git user config" },
	{ file = "~/.config/git/config", desc = "git config (xdg)" },
	{ file = "~/.config/git/ignore", desc = "git global ignore" },
	{ file = "~/.tmux.conf", desc = "tmux" },
	{ file = "~/.config/alacritty/alacritty.toml", desc = "alacritty terminal" },
	{ file = "~/.config/kitty/kitty.conf", desc = "kitty terminal" },
	{ file = "~/.config/starship.toml", desc = "starship prompt" },
	{ file = "~/.config/btop/btop.conf", desc = "btop" },
	{ file = "~/.config/gh/config.yml", desc = "gh cli" },
	{ file = "~/.npmrc", desc = "npm" },
	{ file = "~/.ideavimrc", desc = "ideavim" },
	{ file = "~/.Xresources", desc = "x resources" },
	{ file = "~/.pi/agent/AGENTS.md", desc = "pi global instructions" },
	{ file = "~/.pi/agent/settings.json", desc = "pi agent settings" },
	{ file = "~/.config/mcp/mcp.json", desc = "mcp servers (source)" },
	{ file = "~/.config/mcphub/servers.json", desc = "mcphub servers (generated)" },
}

--- Expands `~` and returns the absolute path.
---@param file string Entry from `bookmarks`.
---@return string? path Absolute path, or nil when the file is gone.
local function resolve(file)
	local path = vim.fs.normalize(file)

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
			items[#items + 1] = { file = path, text = vim.fn.fnamemodify(path, ":~"), desc = entry.desc }
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
