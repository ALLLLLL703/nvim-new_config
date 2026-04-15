local wk = Safe_Require("which-key")
wk.setup({
	preset = "modern",
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
})
