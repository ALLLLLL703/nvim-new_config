local opts = {

	provider = "openai",
	provider_options = {

		openai = {
			model = "gpt-5.4",
			end_point = "https://e-flowcode.cc/v1/chat/completions",
			stream = true,
			api_key = "AVANTE_FLOWCODE_CODEX_API_KEY",
			optional = {
				-- pass any additional parameters you want to send to OpenAI request,
				-- e.g.
				-- stop = { 'end' },
				-- max_completion_tokens = 256,
				-- top_p = 0.9,
				-- reasoning_effort = 'minimal'
				-- reasoning_effort = 'none'
			},
			-- a list of functions to transform the endpoint, header, and request body
			transform = {},
		},
	},
}
Safe_Require("minuet").setup(opts)
