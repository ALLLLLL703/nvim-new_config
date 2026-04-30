---@type YaziConfig
local opts = {
	log_level = 0,
	quit_on_close = false,
	keymaps = { cycle_open_buffers = false },
	-- config_home = "/home/sanae/.config/yazi/nvim/",
}
Safe_Require("yazi").setup(opts)
