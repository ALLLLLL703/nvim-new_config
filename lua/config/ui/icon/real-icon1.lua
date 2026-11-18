local extensions_root = vim.fs.joinpath(vim.uv.os_homedir(), ".vscode-insiders", "extensions")
local builtin_root = "/usr/share/code-insiders/resources/app/extensions"

local extension_themes = {
	["pkief.material-icon-theme"] = "material-icon-theme",
	["vscode-icons-team.vscode-icons"] = "vscode-icons",
	["yusifaliyevpro.vscicons"] = "icons",
}

local builtin_themes = {
	["theme-modern-icons"] = { name = "vscode-insiders-modern", theme = "vscode-modern-icons" },
	["theme-defaults"] = { name = "vscode-insiders-minimal", theme = "vs-minimal" },
}

local packs = {}
for extension, icon_theme in pairs(builtin_themes) do
	local path = vim.fs.joinpath(builtin_root, extension)
	if vim.fn.isdirectory(path) == 1 then
		packs[icon_theme.name] = { type = "vscode", path = path, theme = icon_theme.theme }
	end
end

-- The Insiders extension index identifies the active installation after upgrades.
local index_path = vim.fs.joinpath(extensions_root, "extensions.json")
local read_ok, lines = pcall(vim.fn.readfile, index_path)
if read_ok then
	local ok, extensions = pcall(vim.json.decode, table.concat(lines, "\n"))
	if ok and vim.islist(extensions) then
		for _, extension in ipairs(extensions) do
			local id = type(extension) == "table" and vim.tbl_get(extension, "identifier", "id")
			local theme = type(id) == "string" and extension_themes[id:lower()]
			if theme and type(extension.relativeLocation) == "string" then
				packs[theme] = {
					type = "vscode",
					path = vim.fs.joinpath(extensions_root, extension.relativeLocation),
					theme = theme,
				}
			end
		end
	end
end

vim.opt.termguicolors = true
require("real-icons").setup({
	pack = packs["material-icon-theme"] and "material-icon-theme" or "material",
	packs = packs,
	integrations = {
		bufferline = true,
		lualine = true,
		neo_tree = true,
		oil = true,
		snacks_picker = true,
	},
})
