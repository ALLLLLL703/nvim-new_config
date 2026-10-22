local group = vim.api.nvim_create_augroup("CmakeAnalyzerLsp", {
	clear = true,
})

vim.api.nvim_create_autocmd("FileType", {

	group = group,
	pattern = "cmake",
	callback = function(event)
		local directory = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(event.buf), ":p:h")

		vim.lsp.start({
			name = "cmake_analyzer",
			cmd = {
				vim.fn.expand("~/.local/bin/cmake-analyzer"),
				"--stdio",
			},
			root_dir = vim.fs.root(event.buf, { "CMakeLists.txt" }) or directory,
			on_init = function(client, init_result)
				vim.api.nvim_create_user_command("CmakeAnalyzer", function(opts)
					if opts.args ~= "reloadConfig" then
						vim.notify("Usage: CmakeAnalyzer  reloadConfig", vim.log.levels.ERROR)
					end
					client:request(
						---@diagnostic disable-next-line: param-type-mismatch
						"cmake-analyzer/reloadConfig",
						vim.empty_dict(),
						function(err, result, context, config)
							if err then
								vim.notify(err.message, "error")
								return
							end
							vim.notify("cmake-analyzer configuration reloaded")
						end
					)
				end, {
					nargs = 1,
					complete = function(prefix, line, pos)
						return { "reloadConfig" }
					end,
				})
				client.handlers["window/showMessage"] = require("noice.lsp.message").on_message
			end,
		}, {
			bufnr = event.buf,
			reuse_client = function(client, config)
				return client.name == config.name
			end,
		})
	end,
})
