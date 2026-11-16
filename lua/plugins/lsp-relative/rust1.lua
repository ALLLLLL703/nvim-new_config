---@type LazySpec
return {
	{
		url = "https://github.com/mrcjkb/rustaceanvim",
		-- To avoid being surprised by breaking changes,
		-- I recommend you set a version range
		version = "^9",
		-- rustaceanvim replaces rust_analyzer, so it only has to exist once a Rust buffer opens.
		ft = "rust",
	},
	{

		url = "https://github.com/saecki/crates.nvim",
	},
	{
		url = "https://github.com/cordx56/rustowl",
	},
}
