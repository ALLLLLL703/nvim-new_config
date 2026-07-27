local app_server = require("config.editor-basic.ai.codex_app_server")
local common = require("minuet.backends.common")
local utils = require("minuet.utils")

local M = {}

function M.is_available()
	local options = require("minuet").config.provider_options.codex
	local command = options.command or { "codex" }
	return vim.fn.executable(command[1]) == 1
end

function M.complete(context, callback)
	local config = require("minuet").config
	local options = vim.deepcopy(config.provider_options.codex)
	local timestamp = os.time()
	local system_prompt = utils.make_system_prompt(options.system, config.n_completions)
	local prompt = table.concat(utils.make_chat_llm_shot(context, options.chat_input), "\n")

	utils.run_event("MinuetRequestStartedPre", {
		provider = "codex",
		name = options.name,
		model = options.model,
		n_requests = 1,
		timestamp = timestamp,
	})
	utils.run_event("MinuetRequestStarted", {
		provider = "codex",
		name = options.name,
		model = options.model,
		n_requests = 1,
		request_idx = 1,
		timestamp = timestamp,
	})

	options.system_prompt = system_prompt
	app_server.complete(options, prompt, function(err, text)
		utils.run_event("MinuetRequestFinished", {
			provider = "codex",
			name = options.name,
			model = options.model,
			n_requests = 1,
			request_idx = 1,
			timestamp = timestamp,
		})

		if err then
			if not err.cancelled then
				utils.notify(err.message or "Codex completion failed", "error", vim.log.levels.ERROR)
			end
			callback()
			return
		end

		local items = common.parse_completion_items(text, options.name)
		items = common.filter_context_sequences_in_items(items, context)
		items = utils.trim_completion_items(items)
		callback(items)
	end)
end

return M
