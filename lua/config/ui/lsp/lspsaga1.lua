local lspsaga_opts = {
	lightbulb = {
		enable = true,
		virtual_text = true,
		sign = false,
	},
	hover = {
		open_link = "gx",
	},
}

require("lspsaga").setup(lspsaga_opts)
