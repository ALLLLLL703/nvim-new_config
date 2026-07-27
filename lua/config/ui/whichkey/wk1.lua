local wk = require("which-key")
wk.setup({
	preset = "classic",
	---@type wk.Win.opts
	win = {
		no_overlap = true,
		width = { min = 40, max = 100 },
		height = { max = 30 },
		border = "rounded",
	},
})
wk.add({
	{ "<leader>-", group = "file", icon = "󰇥" },
	{ "<leader>cw", icon = "󰇥" },
	{ "<leader>f", group = "file", icon = "" },
	{ "<leader>c", group = "code", icon = "󰨞" },
	{ "<leader>d", group = "debug", icon = "" },
	{ "<leader>cs", icon = "" },
	{ "<leader>ci", icon = "" },
	{ "<leader>co", icon = "" },
	{ "<leader>ld", icon = "" },
	{ "<leader>ls", icon = "" },
	{ "<leader>lr", icon = "" },
	{ "<leader>l", group = "code", icon = "" },
	{ "<leader>b", group = "buffer", icon = "" },
	{ "<leader>u", group = "ui", icon = "" },
	{ "<leader>uC", icon = "󰔎" },
	{ "<leader>s", group = "split", icon = "󰃻" },
	{ "<leader>sh", icon = "󰤻" },
	{ "<leader>sv", icon = "󰤼" },
	{ "<leader>ss", icon = "", group = "search" },
	{ "<leader>ssi", icon = "" },
	{ "<leader>ssk", icon = "🎹" },
	{ "<leader>fs", icon = "" },
	{ "<leader>fw", icon = "" },
})
