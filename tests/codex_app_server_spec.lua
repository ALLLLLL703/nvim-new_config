local root = vim.fn.getcwd()
vim.opt.runtimepath:prepend(root)

local app_server = require("config.editor-basic.ai.codex_app_server")
local fake_server = root .. "/tests/fixtures/fake_codex_app_server.mjs"
local test_home = "/tmp/opencode/nvim-codex-completion-test"

local function options(timeout_ms)
	return {
		command = { "node", fake_server },
		home = test_home,
		model = "gpt-5.3-codex-spark",
		reasoning_effort = "low",
		timeout_ms = timeout_ms or 1000,
		system_prompt = "Return code completions only.",
	}
end

local function wait_for(predicate, message)
	assert(vim.wait(2000, predicate, 10), message)
end

local first_result
app_server.complete(options(), "complete this", function(err, text)
	first_result = { err = err, text = text }
end)
wait_for(function()
	return first_result ~= nil
end, "first completion timed out")
assert(first_result.err == nil, first_result.err and first_result.err.message)
assert(first_result.text == "first<endCompletion>second", "unexpected completion text")

local cancelled_result
local replacement_result
app_server.complete(options(), "SLOW completion", function(err, text)
	cancelled_result = { err = err, text = text }
end)
app_server.complete(options(), "replacement completion", function(err, text)
	replacement_result = { err = err, text = text }
end)
wait_for(function()
	return cancelled_result ~= nil and replacement_result ~= nil
end, "replacement completion timed out")
assert(cancelled_result.err and cancelled_result.err.cancelled, "stale completion was not cancelled")
assert(replacement_result.err == nil, replacement_result.err and replacement_result.err.message)
assert(replacement_result.text == "first<endCompletion>second", "replacement completion was not returned")

local delayed_cancel_result
local delayed_replacement_result
app_server.complete(options(), "DELAY_RESPONSE old completion", function(err, text)
	delayed_cancel_result = { err = err, text = text }
end)
vim.defer_fn(function()
	app_server.complete(options(), "replacement after delayed response", function(err, text)
		delayed_replacement_result = { err = err, text = text }
	end)
end, 20)
wait_for(function()
	return delayed_cancel_result ~= nil and delayed_replacement_result ~= nil
end, "delayed replacement completion timed out")
assert(delayed_cancel_result.err and delayed_cancel_result.err.cancelled, "pending turn was not cancelled")
assert(delayed_replacement_result.err == nil, delayed_replacement_result.err and delayed_replacement_result.err.message)
assert(delayed_replacement_result.text == "first<endCompletion>second", "old turn contaminated replacement")

local timeout_result
app_server.complete(options(20), "DELAY_RESPONSE SLOW timeout", function(err, text)
	timeout_result = { err = err, text = text }
end)
wait_for(function()
	return timeout_result ~= nil
end, "timeout callback was not called")
assert(timeout_result.err and timeout_result.err.message == "Codex completion timed out", "timeout was not reported")
vim.wait(250, function()
	return false
end, 10)

local retry_result
app_server.complete(options(), "RETRY completion", function(err, text)
	retry_result = { err = err, text = text }
end)
wait_for(function()
	return retry_result ~= nil
end, "retry completion timed out")
assert(retry_result.err == nil, "retryable error ended completion")
assert(retry_result.text == "first<endCompletion>second", "retry completion returned wrong text")

local failure_result
app_server.complete(options(), "FAIL completion", function(err, text)
	failure_result = { err = err, text = text }
end)
wait_for(function()
	return failure_result ~= nil
end, "failure completion timed out")
assert(failure_result.err and failure_result.err.message == "fake failure", "provider error message was lost")

vim.cmd.packadd("minuet-ai.nvim")
local minuet_config = require("minuet.config")
require("minuet").setup({
	provider = "codex",
	n_completions = 2,
	notify = false,
	provider_options = {
		codex = {
			name = "Codex test",
			command = { "node", fake_server },
			home = test_home,
			model = "gpt-5.3-codex-spark",
			reasoning_effort = "low",
			timeout_ms = 1000,
			system = minuet_config.default_system_prefix_first,
			chat_input = minuet_config.default_chat_input_prefix_first,
		},
	},
})

local provider_result
require("minuet.backends.codex").complete({
	lines_before = "local value = ",
	lines_after = "",
	opts = { is_incomplete_before = false, is_incomplete_after = false },
}, function(items)
	provider_result = items
end)
wait_for(function()
	return provider_result ~= nil
end, "Minuet provider completion timed out")
assert(vim.deep_equal(provider_result, { "first", "second" }), "Minuet provider did not parse completion items")

app_server.stop()
local restart_result
app_server.complete(options(), "completion after restart", function(err, text)
	restart_result = { err = err, text = text }
end)
wait_for(function()
	return restart_result ~= nil
end, "completion after restart timed out")
assert(restart_result.err == nil, restart_result.err and restart_result.err.message)
vim.wait(150, function()
	return false
end, 10)

local post_exit_result
app_server.complete(options(), "completion after old process exit", function(err, text)
	post_exit_result = { err = err, text = text }
end)
wait_for(function()
	return post_exit_result ~= nil
end, "old process exit corrupted restarted server")
assert(post_exit_result.err == nil, post_exit_result.err and post_exit_result.err.message)

local missing_result
app_server.complete(
	vim.tbl_extend("force", options(), { command = { "missing-codex-test-command" } }),
	"x",
	function(err)
		missing_result = err
	end
)
assert(missing_result and missing_result.message:find("was not found", 1, true), "missing executable was not reported")

app_server.stop()
print("codex_app_server_spec: ok")
