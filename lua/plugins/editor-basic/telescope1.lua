---@type LazySpec
return {
	{
		url = "https://github.com/nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		config = function()
			local ok, err = require("real-icons").enable_integration("telescope")
			if not ok then
				vim.notify("real-icons: " .. tostring(err), vim.log.levels.WARN)
			end
		end,
	},
}
