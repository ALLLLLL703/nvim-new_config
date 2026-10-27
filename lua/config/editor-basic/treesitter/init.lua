local languages = { "rust", "javascript", "zig", "lua", "c", "cpp", "markdown" }

--- Whether a parser for this language can be found on the runtimepath.
---
--- nvim-treesitter counts a language as installed from the queries it has copied, so a parser
--- that went missing under a leftover query directory turns plain install() into a silent no-op.
--- @param language string
--- @return boolean
local function has_parser(language)
	return #vim.api.nvim_get_runtime_file("parser/" .. language .. ".*", false) > 0
end

local missing = vim.tbl_filter(function(language)
	return not has_parser(language)
end, languages)

local treesitter = require("nvim-treesitter")
if #missing > 0 then
	treesitter.install(missing, { force = true })
else
	treesitter.install(languages)
end
