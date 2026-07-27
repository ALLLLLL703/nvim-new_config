require("config.lsp-relative.jdtls.attach2").attach()

-- 注册 jdt:// 协议处理器
-- vim.api.nvim_create_autocmd("BufReadCmd", {
-- 	pattern = "jdt://*",
-- 	callback = function()
-- 		local uri = vim.fn.expand("<amatch>")
-- 		-- 调用 jdtls 自定义的命令来获取源码内容
-- 		vim.lsp.buf_request(0, "java/classFileContents", { uri = uri }, function(err, result)
-- 			if err then
-- 				vim.api.nvim_err_writeln("JDTLS: Error fetching content: " .. err.message)
-- 				return
-- 			end
-- 			if not result then
-- 				return
-- 			end
--
-- 			-- 将内容写入当前缓冲区
-- 			vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result, "\n"))
-- 			vim.api.nvim_set_option_value("readonly", true, { buf = 0 })
-- 			vim.api.nvim_set_option_value("buftype", "nofile", { buf = 0 })
-- 			-- 开启 Java 语法高亮
-- 			vim.api.nvim_set_option_value("filetype", "java", { buf = 0 })
-- 		end)
-- 	end,
-- })
local group = vim.api.nvim_create_augroup("config.jdt_classfiles", { clear = true })

vim.api.nvim_create_autocmd("BufReadCmd", {
	group = group,
	pattern = "jdt://*",
	callback = function()
		local uri = vim.fn.expand("<amatch>")
		-- nvim-jdtls 提供的标准跳转 API
		require("jdtls").open_classfile(uri)
	end,
	desc = "Open JDT class file",
})
