require("lensline").setup({

	profiles = {
		{
			name = "basic",
			providers = {
				{ name = "usages", enabled = true, include = { "refs", "impls" }, breakdown = true },
				{ name = "last_author", enabled = true },
				{ name = "complexity", enabled = true },
			},
		},
		{
			name = "comperhensive",
			providers = {
				{ name = "usages", enabled = true, include = { "refs", "defs", "impls" }, breakdown = true },
				{ name = "diagnostics", enabled = true, min_level = "HINT" },
				{ name = "complexity", enabled = true },
				{ name = "last_author", enabled = true },
			},
		},
	},
})
