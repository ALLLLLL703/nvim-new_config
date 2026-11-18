---@type LazySpec
return {
	{
		url = "https://github.com/lewis6991/async.nvim",
		enabled = function()
			return vim.async == nil
		end,
		lazy = false,
		priority = 900,
		init = function()
			local promise = require("lazy.core.config").plugins["promise-async"]
			if promise then
				-- nvim-ufo needs the callable module from promise-async.
				-- https://github.com/ThePrimeagen/refactoring.nvim/issues/546
				package.preload.async = assert(loadfile(vim.fs.joinpath(promise.dir, "lua", "async.lua")))
			end
		end,
		config = function(plugin)
			-- Use the same entry point that refactoring.nvim uses on Neovim 0.13.
			vim.async = assert(loadfile(vim.fs.joinpath(plugin.dir, "lua", "async.lua")))()
		end,
	},
}
