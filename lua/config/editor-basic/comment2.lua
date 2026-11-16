local ft = require("Comment.ft")
local utils = require("Comment.utils")

ft({ "go", "rust", "jsonc" }, { "//%s", "/*%s*/" })

-- Neovim 0.12 changed two things Comment.nvim still assumes the old way: `vim.treesitter.get_parser`
-- now returns `nil, err` instead of raising, and `TSNode:children()` now returns a list instead of a
-- `lang -> node` map. Upstream therefore dereferences a nil parser and the generic handler reports
-- the crash as `[Comment.nvim] nil`. The fixes live here instead of in the plugin checkout, which
-- `:Lazy update` overwrites.

--- Commentstring of the language nested at `range`, or the tree itself when nothing nests.
---@param tree vim.treesitter.LanguageTree
---@param range integer[]
---@return vim.treesitter.LanguageTree
local function contains(tree, range)
	for _, child in pairs(tree:children()) do
		local ok, lang, nested = pcall(function()
			return child:lang(), child:contains(range)
		end)

		if ok and lang ~= "comment" and nested then
			return contains(child, range)
		end
	end

	return tree
end

--- Commentstring for the current buffer, falling back to the filetype when treesitter cannot help.
---@param ctx CommentCtx
---@return nil|string
local function calculate(ctx)
	local ok, parser = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())

	if not ok or not parser then
		return ft.get(vim.bo.filetype, ctx.ctype)
	end

	local range = { ctx.range.srow - 1, ctx.range.scol, ctx.range.erow - 1, ctx.range.ecol }
	local parsed, lang = pcall(function()
		return contains(parser, range):lang()
	end)

	if not parsed then
		return ft.get(vim.bo.filetype, ctx.ctype)
	end

	return ft.get(lang, ctx.ctype) or ft.get(vim.bo.filetype, ctx.ctype)
end

rawset(ft, "contains", contains)
rawset(ft, "calculate", calculate)

-- `xpcall` passes a plain string to the handler for `error("...")`, so reading `err.msg` turned every
-- real failure into `[Comment.nvim] nil`.
---@param fn function
utils.catch = function(fn, ...)
	xpcall(fn, function(err)
		local msg = type(err) == "table" and (err.msg or err.message) or err
		vim.notify(string.format("[Comment.nvim] %s", tostring(msg)), vim.log.levels.WARN)
	end, ...)
end

require("Comment").setup()
