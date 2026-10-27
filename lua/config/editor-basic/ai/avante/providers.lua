--- Avante model providers.
---
--- Only DeepSeek is wired up: it is the model that matches the pi setup this
--- configuration is ported from.
local Credentials = require("config.editor-basic.ai.avante.credentials")

local M = {}

local deepseek_env = "DEEPSEEK_API_KEY"

--- Avante reads `api_key_name` through `os.getenv`, so the resolved key has to
--- exist in the process environment before `require("avante").setup()` runs.
local function export_deepseek_key()
	local credential = Credentials.resolve("deepseek", deepseek_env)
	if credential then
		vim.env[deepseek_env] = credential.api_key
	end
end

--- DeepSeek exposes an OpenAI-compatible `/chat/completions` endpoint, hence the
--- `__inherited_from = "openai"` functor instead of a hand-written curl parser.
---@return table<string, AvanteProviderFunctor>
function M.build()
	export_deepseek_key()

	return {
		deepseek = {
			__inherited_from = "openai",
			endpoint = "https://api.deepseek.com/v1",
			model = "deepseek-flash",
			api_key_name = deepseek_env,
			timeout = 30000,
			context_window = 1000000,
			extra_request_body = {
				temperature = 0.75,
				max_tokens = 384000,
			},
		},
	}
end

return M
