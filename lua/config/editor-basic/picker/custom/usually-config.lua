local M = {}

--- Config files worth reopening often, wherever they live on this machine. Every entry is an
--- absolute path or starts with `~`, so these resolve the same from any working directory.
---@type { file: string, desc: string }[]
local global_bookmarks = {
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
	{ file = "~/.codex/config.toml", desc = "codex config" },
	{ file = "~/.codex/AGENTS.md", desc = "codex instructions" },
	{ file = "~/.pi/agent/AGENTS.md", desc = "pi global instructions" },
	{ file = "~/.pi/agent/settings.json", desc = "pi agent settings" },
	{ file = "~/.pi/agent/mcp.json", desc = "pi mcp servers" },
	{ file = "~/.config/mcp/mcp.json", desc = "mcp servers (source)" },
	{ file = "~/.config/mcphub/servers.json", desc = "mcphub servers (generated)" },
}

--- Config files that only exist per project. Resolved against the project root, and silently
--- skipped when the current project does not have them.
---@type { file: string, desc: string }[]
local project_bookmarks = {
	{ file = ".gitignore", desc = "git ignore" },
	{ file = ".git/info/exclude", desc = "git local exclude" },
	{ file = ".mcp.json", desc = "project mcp servers" },
	{ file = "Cargo.toml", desc = "rust manifest" },
	{ file = "rust-toolchain.toml", desc = "rust toolchain" },
	{ file = "rustfmt.toml", desc = "rustfmt" },
	{ file = "package.json", desc = "node manifest" },
	{ file = "pyproject.toml", desc = "python manifest" },
	{ file = "go.mod", desc = "go module" },
	{ file = ".editorconfig", desc = "editorconfig" },
	{ file = "CMakeLists.txt", desc = "root cmake" },
}

--- Project root of the current session: the worktree of the buffer being edited, else the one of the
--- cwd, else the cwd itself, so the picker still works outside of git.
---@return string
local function project_root()
	local buf = vim.api.nvim_buf_get_name(0)

	if buf ~= "" then
		local root = vim.fs.root(buf, { ".git" })
		if root then
			return root
		end
	end

	return vim.fs.root(vim.fn.getcwd(), { ".git" }) or vim.fn.getcwd()
end

--- Expands `~` and returns the absolute path.
---@param file string Entry from either bookmark list.
---@return string? path Absolute path, or nil when the file is gone.
local function resolve(file)
	local path = vim.fs.normalize(file)

	if not vim.uv.fs_stat(path) then
		return nil
	end

	return path
end

--- Opens a picker with the global bookmarks plus the ones the current project happens to have.
--- Stale global entries are dropped and reported; absent project entries are expected and skipped.
function M.config_bookmarks()
	local items = {}
	local missing = {}

	for _, entry in ipairs(global_bookmarks) do
		local path = resolve(entry.file)

		if path then
			items[#items + 1] = { file = path, text = vim.fn.fnamemodify(path, ":~"), desc = entry.desc }
		else
			missing[#missing + 1] = entry.file
		end
	end

	local root = project_root()
	for _, entry in ipairs(project_bookmarks) do
		local path = resolve(vim.fs.joinpath(root, entry.file))

		if path then
			items[#items + 1] = { file = path, text = entry.file, desc = entry.desc .. " (project)" }
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
