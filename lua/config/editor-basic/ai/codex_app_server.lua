local M = {}

local state = {
	job_id = nil,
	next_id = 1,
	pending = {},
	ready_callbacks = {},
	stdout_tail = "",
	stderr_tail = "",
	starting = false,
	initialized = false,
	stopping_job_id = nil,
	active = nil,
	threads = {},
}

local function command_name(command)
	return type(command) == "table" and command[1] or command
end

local function send(message)
	if not state.job_id then
		return false
	end

	return vim.fn.chansend(state.job_id, vim.json.encode(message) .. "\n") > 0
end

local function request(method, params, callback)
	local id = state.next_id
	state.next_id = state.next_id + 1
	state.pending[tostring(id)] = callback
	if not send({ id = id, method = method, params = params }) then
		state.pending[tostring(id)] = nil
		callback({ message = "Codex app-server input stream is unavailable" })
	end
end

local function close_timer(active)
	if active.timer and not active.timer:is_closing() then
		active.timer:stop()
		active.timer:close()
	end
	active.timer = nil
end

local function unsubscribe(active)
	if active.unsubscribed or not active.thread_id then
		return
	end

	active.unsubscribed = true
	state.threads[active.thread_id] = nil
	if state.job_id then
		request("thread/unsubscribe", { threadId = active.thread_id }, function() end)
	end
end

local function interrupt_and_unsubscribe(active)
	if active.cancelled and active.turn_request_sent and not active.turn_id then
		return
	end

	if active.cancelled and active.thread_id and active.turn_id and state.job_id then
		request("turn/interrupt", {
			threadId = active.thread_id,
			turnId = active.turn_id,
		}, function() end)
		unsubscribe(active)
		return
	end

	unsubscribe(active)
end

local function finish_active(active, err, text)
	if active.finished then
		return
	end

	active.finished = true
	close_timer(active)
	if state.active == active then
		state.active = nil
	end
	interrupt_and_unsubscribe(active)
	active.callback(err, text)
end

local function cancel_active()
	local active = state.active
	if not active then
		return
	end

	active.cancelled = true
	finish_active(active, { cancelled = true })
end

local function fail_all(message)
	local err = { message = message }
	local pending = state.pending
	state.pending = {}
	for _, callback in pairs(pending) do
		callback(err)
	end

	local callbacks = state.ready_callbacks
	state.ready_callbacks = {}
	for _, callback in ipairs(callbacks) do
		callback(err)
	end

	if state.active then
		finish_active(state.active, err)
	end
	state.threads = {}
end

local function dispatch(message)
	if message.id ~= nil and (message.result ~= nil or message.error ~= nil) then
		local key = tostring(message.id)
		local callback = state.pending[key]
		state.pending[key] = nil
		if callback then
			callback(message.error, message.result)
		end
		return
	end

	local params = message.params or {}
	local active = params.threadId and state.threads[params.threadId] or nil
	if not active then
		return
	end

	if message.method == "item/agentMessage/delta" then
		active.text = active.text .. (params.delta or "")
	elseif message.method == "turn/completed" then
		local turn = params.turn or {}
		if turn.status == "failed" then
			finish_active(active, { message = turn.error and turn.error.message or "Codex completion failed" })
		else
			finish_active(active, nil, active.text)
		end
	elseif message.method == "error" and not params.willRetry then
		local err = params.error or {}
		finish_active(active, { message = err.message or params.message or "Codex app-server error" })
	end
end

local function handle_line(line)
	if line == "" then
		return
	end

	local ok, message = pcall(vim.json.decode, line)
	if ok and type(message) == "table" then
		dispatch(message)
	end
end

local function feed_stdout(data)
	if not data then
		return
	end

	for index, chunk in ipairs(data) do
		if index == 1 then
			chunk = state.stdout_tail .. chunk
			state.stdout_tail = ""
		end
		if index < #data then
			handle_line(chunk)
		else
			state.stdout_tail = chunk
		end
	end
end

local function flush_ready(err)
	local callbacks = state.ready_callbacks
	state.ready_callbacks = {}
	for _, callback in ipairs(callbacks) do
		callback(err)
	end
end

local function start(options)
	state.starting = true
	state.stdout_tail = ""
	state.stderr_tail = ""

	local home = options.home
	vim.fn.mkdir(home, "p")
	local env = vim.fn.environ()
	env.HOME = home
	env.CODEX_HOME = home

	local command = options.command or { "codex", "app-server", "--listen", "stdio://" }
	state.job_id = vim.fn.jobstart(command, {
		cwd = home,
		env = env,
		clear_env = true,
		stdin = "pipe",
		stdout_buffered = false,
		stderr_buffered = false,
		on_stdout = function(job_id, data)
			if state.job_id == job_id then
				feed_stdout(data)
			end
		end,
		on_stderr = function(job_id, data)
			if state.job_id == job_id and data then
				state.stderr_tail = vim.trim(table.concat(data, "\n")):sub(-2000)
			end
		end,
		on_exit = function(job_id, code)
			local is_current = state.job_id == job_id
			local expected = state.stopping_job_id == job_id or not is_current
			if state.stopping_job_id == job_id then
				state.stopping_job_id = nil
			end
			if not is_current then
				return
			end

			state.job_id = nil
			state.starting = false
			state.initialized = false
			if not expected then
				vim.schedule(function()
					local detail = state.stderr_tail ~= "" and ": " .. state.stderr_tail or ""
					fail_all("Codex app-server exited with code " .. code .. detail)
				end)
			end
		end,
	})

	if state.job_id <= 0 then
		state.job_id = nil
		state.starting = false
		flush_ready({ message = "Failed to start Codex app-server" })
		return
	end

	request("initialize", {
		clientInfo = {
			name = "minuet-codex-completion",
			title = "Minuet Codex completion",
			version = "1.0.0",
		},
		capabilities = { experimentalApi = true },
	}, function(err)
		state.starting = false
		if err then
			local job_id = state.job_id
			state.job_id = nil
			if job_id then
				state.stopping_job_id = job_id
				vim.fn.jobstop(job_id)
			end
			flush_ready(err)
			return
		end

		send({ method = "initialized", params = {} })
		state.initialized = true
		flush_ready()
	end)
end

local function ensure_started(options, callback)
	if state.initialized and state.job_id then
		callback()
		return
	end

	table.insert(state.ready_callbacks, callback)
	if state.starting then
		return
	end
	start(options)
end

local function start_timeout(active, timeout_ms)
	active.timer = vim.uv.new_timer()
	active.timer:start(
		timeout_ms,
		0,
		vim.schedule_wrap(function()
			active.cancelled = true
			finish_active(active, { message = "Codex completion timed out" })
		end)
	)
end

---@class CodexCompletionOptions
---@field command? string[]
---@field home string
---@field model string
---@field reasoning_effort string
---@field timeout_ms integer
---@field system_prompt string

---@param options CodexCompletionOptions
---@param prompt string
---@param callback fun(err: table?, text: string?)
function M.complete(options, prompt, callback)
	cancel_active()

	local executable = command_name(options.command or { "codex" })
	if vim.fn.executable(executable) ~= 1 then
		callback({ message = "Codex executable was not found: " .. executable })
		return
	end

	local active = {
		callback = callback,
		finished = false,
		text = "",
	}
	state.active = active
	start_timeout(active, options.timeout_ms)

	ensure_started(options, function(start_err)
		if start_err or active.finished then
			if start_err then
				finish_active(active, start_err)
			end
			return
		end

		request("thread/start", {
			model = options.model,
			cwd = options.home,
			runtimeWorkspaceRoots = { options.home },
			approvalPolicy = "never",
			sandbox = "read-only",
			baseInstructions = options.system_prompt,
			developerInstructions = "Return only completion candidates and do not call tools.",
			ephemeral = true,
			sessionStartSource = "startup",
			threadSource = "user",
			dynamicTools = {},
			experimentalRawEvents = false,
			persistExtendedHistory = false,
			config = {
				project_doc_max_bytes = 0,
				model_reasoning_effort = options.reasoning_effort,
			},
		}, function(thread_err, result)
			if thread_err then
				finish_active(active, thread_err)
				return
			end

			active.thread_id = result.thread.id
			if active.finished then
				interrupt_and_unsubscribe(active)
				return
			end

			state.threads[active.thread_id] = active
			active.turn_request_sent = true
			request("turn/start", {
				threadId = active.thread_id,
				input = { { type = "text", text = prompt } },
				cwd = options.home,
				runtimeWorkspaceRoots = { options.home },
				approvalPolicy = "never",
				model = options.model,
				effort = options.reasoning_effort,
				sandboxPolicy = { type = "readOnly" },
			}, function(turn_err, turn_result)
				if turn_err then
					if active.finished then
						unsubscribe(active)
					else
						finish_active(active, turn_err)
					end
					return
				end
				active.turn_id = turn_result.turn.id
				if active.finished then
					interrupt_and_unsubscribe(active)
				end
			end)
		end)
	end)
end

function M.stop()
	cancel_active()
	local job_id = state.job_id
	if job_id then
		state.stopping_job_id = job_id
		vim.fn.jobstop(job_id)
	end
	state.job_id = nil
	state.starting = false
	state.initialized = false
	state.pending = {}
	state.ready_callbacks = {}
	state.threads = {}
end

local group = vim.api.nvim_create_augroup("config.codex_completion", { clear = true })
vim.api.nvim_create_autocmd("VimLeavePre", {
	group = group,
	callback = M.stop,
	desc = "Stop Codex completion app-server",
})

return M
