---@module 'avante'
---@type avante.Config
local opts = {

	provider = "claude",

	---@type avante.Providers
	---@diagnostic disable-next-line: missing-fields
	providers = {

		---@type AvanteProviderFunctor
		claude = {
			endpoint = "https://e-flowcode.cc",
			timeout = 30000,
			extra_request_body = {
				temperature = 0.75,
				max_tokens = 20480,
			},
			api_key_name = "AVANTE_FLOWCODE_API_KEY",
			model = "claude-sonnet-4-6",
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
		},
	},
}
require("avante").setup(opts)
