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
	-- 备份原有的 open_link 函数
	local original_open_link = saga_hover.open_link

	-- 重新定义它
	---@diagnostic disable-next-line: duplicate-set-field
	saga_hover.open_link = function()
		-- Lspsaga 的跳转逻辑通常是获取光标下的 URL
		-- 我们直接从当前光标位置提取 cfile
		local url = vim.fn.expand("<cfile>")

		if url:match("^jdt://") then
			-- 既然在浮窗里，先关掉浮窗
			vim.cmd("SagaClose")
			-- 使用我们验证成功的 edit 命令跳转
			vim.cmd("edit " .. vim.fn.fnameescape(url))
		else
			-- 如果不是 jdt，则调用原来的逻辑（处理 https 等）
			original_open_link()
		end
	end
end
