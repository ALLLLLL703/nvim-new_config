local saga_hover = require("lspsaga.hover")
local original_open_link = saga_hover.open_link

-- 备份原有的 open_link 函数
---@return string?
local function extract_jdt_uri_at_cursor()
	local _, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	local candidates = {}
	for start_pos, end_pos in line:gmatch("()jdt://[^%s&)]+()") do
		table.insert(candidates, { start_pos = start_pos, end_pos = end_pos - 1 })
	end
	if #candidates == 0 then
		return nil
	end
	for _, candidate in ipairs(candidates) do
		if col + 1 >= candidate.start_pos then
			local uri = line:sub(candidate.start_pos, candidate.end_pos)
			return uri:gsub("[`>]+$", ""):gsub("^[`>]+", "")
		end
	end

	local uri = line:sub(candidates[1].start_pos, candidates[1].end_pos)
	return uri:gsub("[`>]+$", ""):gsub("^[`>]+", "")
end

function saga_hover:open_link()
	local uri = extract_jdt_uri_at_cursor()
	if uri and uri:match("^jdt://") then
		vim.cmd.edit(vim.fn.fnameescape(uri))
		return
	end

	return original_open_link(self)
end
