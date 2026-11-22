---@type LazySpec
return {
	-- 'https://github.com/nvim-mini/mini.icons',        -- if you use standalone mini plugins
	-- 'https://github.com/nvim-tree/nvim-web-devicons', -- if you prefer nvim-web-devicons
	{

		url = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
	},
	{
		url = "https://github.com/iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		-- The interactive installer opens a terminal window, so a headless install would skip it.
		-- The sync variant runs `app/install.sh` with the plugin's own version instead.
		build = ":call mkdp#util#install_sync()",
	},
}
