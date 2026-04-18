local M = {
	lightbulb = {
		enable = true,
		virtual_text = true,
		sign = false,
	},
	hover = {
		open_link = "gx",
	},
}

Safe_Require("lspsaga").setup(M)
local saga_hover = Safe_Require("lspsaga.hover")

if saga_hover then
	local original_open_link = saga_hover.open_link
	---@return string
	-- 备份原有的 open_link 函数

	local function extract_jdt_uri_at_cursor()
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local line = vim.api.nvim_get_current_line()

		local candidates = {}
		for s, e in line:gmatch("()jdt://[^%s&)]+()") do
			table.insert(candidates, { s = s, e = e - 1 })
		end
		if #candidates == 0 then
			return nil
		end
		for _, c in ipairs(candidates) do
			if col + 1 >= c.s then
				local uri = line:sub(c.s, c.e)
				uri = uri:gsub("[`>]+$", ""):gsub("^[`>]+", "")
				return uri
			end
		end
		local uri = line:sub(candidates[1].s, candidates[1].e)
		uri = uri:gsub("[`>]+$", ""):gsub("^[`>]+", "")
		return uri
	end
	function saga_hover:open_link()
		local uri = extract_jdt_uri_at_cursor()
		if uri and uri:match("^jdt://") then
			local ok, jdtls = pcall(require, "jdtls")
			if ok and jdtls and jdtls.open_classfile then
				vim.cmd("edit " .. vim.fn.fnameescape(uri))
			else
				vim.cmd("edit " .. vim.fn.fnameescape(uri))
			end
			return
		end
		return original_open_link(self)
	end
end
