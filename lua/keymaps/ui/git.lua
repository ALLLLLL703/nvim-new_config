---@param key string
---@param cmd string
---@param desc? string
local function mapn(key, cmd, desc)
	vim.keymap.set("n", key, cmd, { silent = true, desc = desc })
end

mapn("<leader>gb", "<cmd>Gitsigns blame_line<cr>", "Show line blame")
