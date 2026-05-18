---@module 'avante'
---@type avante.Config
local opts = {

	provider = "claude",

	behaviour = {
		auto_suggestions = false,
	},
	mappings = {
		suggestion = {
			accept = "<A-CR>",
		},
	},

	---@type avante.Providers
	---@diagnostic disable-next-line: missing-fields
	providers = {
		---@type AvanteProviderFunctor
		claude = {
			endpoint = "https://e-flowcode.cc",
			timeout = 30000,
			api_key_name = "AVANTE_FLOWCODE_API_KEY",
			model = "claude-sonnet-4-6",
			extra_request_body = {
				temperature = 0.75,
				max_tokens = 20480,
			},
		},
		---@type AvanteProviderFunctor
		---@diagnostic disable-next-line: missing-fields
		openai = {
			endpoint = "https://e-flowcode.cc/v1",
			timeout = 30000,
			extra_request_body = {
				temperature = 0.75,
				max_tokens = 20480,
			},
			model = "gpt-5.4",
			api_key_name = "AVANTE_FLOWCODE_CODEX_API_KEY",
		},
	},
}
require("avante").setup(opts)
