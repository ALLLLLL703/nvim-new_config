local opts = {
	provider = "codex",
	request_timeout = 30,
	provider_options = {
		codex = {
			name = "Codex Spark",
			command = { "codex", "app-server", "--listen", "stdio://" },
			home = vim.fn.stdpath("cache") .. "/codex-completion",
			model = "gpt-5.3-codex-spark",
			reasoning_effort = "low",
			timeout_ms = 30000,
			system = require("minuet.config").default_system_prefix_first,
			chat_input = require("minuet.config").default_chat_input_prefix_first,
		},
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
require("minuet").setup(opts)
