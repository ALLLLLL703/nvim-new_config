local M = {}

local uri_prefix = "gradle-lsp://"

---@param client vim.lsp.Client
---@return string?
local function external_document_request(client)
	local experimental = client.server_capabilities.experimental
	local gradle_lsp = type(experimental) == "table" and experimental["gradleLsp"] or nil
	local external_document = type(gradle_lsp) == "table" and gradle_lsp["externalDocument"] or nil
	if type(external_document) ~= "table" or external_document.uriScheme ~= "gradle-lsp" then
		return nil
	end
	if type(external_document.request) ~= "string" then
		return nil
	end
	return external_document.request
end

---@param bufnr integer
---@param content table
local function populate_buffer(bufnr, content)
	local text = type(content.text) == "string" and content.text or ""
	local lines = vim.split(text, "\n", { plain = true })
	local has_final_newline = lines[#lines] == ""
	if has_final_newline then
		table.remove(lines)
	end
	if #lines == 0 then
		lines = { "" }
	end

	vim.bo[bufnr].readonly = false
	vim.bo[bufnr].modifiable = true
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.bo[bufnr].endofline = has_final_newline
	vim.bo[bufnr].filetype = content.languageId == "java" and "java" or "kotlin"
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].bufhidden = "hide"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].modified = false
	vim.bo[bufnr].modifiable = false
	vim.bo[bufnr].readonly = true
	vim.b[bufnr].gradle_lsp_external_loaded = true
end

---@param bufnr integer
---@param uri string
local function load_external_document(bufnr, uri)
	local last_error
	for _, client in ipairs(vim.lsp.get_clients()) do
		local request = external_document_request(client)
		if request then
			-- BufReadCmd must provide text before Neovim applies the definition range.
			-- This bounded request only reads the server's in-memory document store.
			local response, request_error = client:request_sync(request, { uri = uri }, 1000, bufnr)
			local content = response and response.result or nil
			if not response then
				last_error = request_error
			elseif response.err then
				last_error = response.err.message
			elseif type(content) == "table" and content.uri == uri then
				populate_buffer(bufnr, content)
				return
			end
		end
	end

	local suffix = last_error and (": " .. last_error) or ""
	vim.notify("Gradle LSP: external document is unavailable" .. suffix, vim.log.levels.ERROR)
end

function M.setup()
	local group = vim.api.nvim_create_augroup("config.gradle_lsp_external", { clear = true })
	vim.api.nvim_create_autocmd("BufReadCmd", {
		group = group,
		pattern = uri_prefix .. "*",
		callback = function(args)
			if not vim.b[args.buf].gradle_lsp_external_loaded then
				load_external_document(args.buf, args.match)
			end
		end,
		desc = "Load Gradle LSP external documents",
	})
end

return M
