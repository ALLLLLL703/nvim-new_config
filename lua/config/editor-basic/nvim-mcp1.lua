-- Expose this Neovim instance to the `nvim-mcp` MCP server over a project-scoped
-- RPC socket. Git spawns throwaway instances for commit/merge/rebase messages;
-- those must not register a second socket in the same git root.
local transient = false
for _, arg in ipairs(vim.fn.argv()) do
	if
		arg:match("COMMIT_EDITMSG$")
		or arg:match("MERGE_MSG$")
		or arg:match("git%-rebase%-todo$")
		or arg:match("TAG_EDITMSG$")
	then
		transient = true
	end
end

if not transient then
	require("nvim-mcp").setup({})
end
