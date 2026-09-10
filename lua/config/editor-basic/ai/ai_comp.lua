require("ai_comp").setup({
	model = "gpt-5.3-codex-spark",
	debounce_ms = 250,
	timeout_ms = 15000,
	-- Blink owns completion display and acceptance.
	inline = { enabled = false },
})
