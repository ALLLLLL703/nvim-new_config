local map = vim.keymap.set

local codex_opend_flag = false

local function toggle_codex()
	if not codex_opend_flag then
		vim.cmd("CodexToggle")
		-- vim.cmd("startinsert")
		codex_opend_flag = not codex_opend_flag
	else
		vim.cmd("CodexToggle")
		codex_opend_flag = not codex_opend_flag
	end
end

-- map("n", "<leader>a?", "<cmd>AvanteModels<cr>", { desc = "select models" })
--
-- map("n", "<leader>ae", "<cmd>AvanteEdit<cr>", { desc = "edit code blocks" })
-- map("v", "<leader>ae", "<cmd>'<,'>AvanteEdit<cr>", { desc = "edit code blocks" })
-- map("n", "<leader>aS", "<cmd>AvanteStop<cr>", { desc = "stop current request" })
-- map("n", "<leader>ah", "<cmd>AvanteHistory<cr>", { desc = "chat history" })
-- map("n", "<leader>ad", "<cmd>AvanteShowRepoMap<cr>", { desc = "repo map" })
-- map("n", "<leader>aa", "<cmd>AvanteToggle<cr>", { desc = "show side bar" })
-- map("n", "<leader>ar", "<cmd>AvanteRefresh<cr>", { desc = "refresh side bar" })
-- map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "claude code toggle" })
map("n", "<leader>ao", "<cmd>Opencode<cr>", { desc = "Toggle OpenCode", silent = true })
map("n", "<leader>as", "<cmd>Opencode session select<cr>", { desc = "Select an OpenCode session", silent = true })
map("n", "<leader>aS", "<cmd>Opencode skills<cr>", { desc = "Open OpenCode skills", silent = true })
map("n", "<leader>an", "<cmd>Opencode session new<cr>", { desc = "Create an OpenCode session", silent = true })
map("n", "<leader>am", "<cmd>Opencode models<cr>", { desc = "Select an OpenCode model", silent = true })
map("n", "<leader>aM", "<cmd>Opencode mcp<cr>", { desc = "Open OpenCode MCP tools", silent = true })

map("n", "<leader>ax", toggle_codex, { desc = "Toggle Codex" })
