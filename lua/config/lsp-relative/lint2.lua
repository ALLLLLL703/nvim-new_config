require("lint").linters_by_ft = {
	python = { "pyrefly", "pylint" },
	cmake = { "cmake_lint" },
	cpp = { "clangtidy" },
	c = { "clangtidy" },
}

local group = vim.api.nvim_create_augroup("config.lint", { clear = true })

---@param filetype string
---@param desc string
local function make_lint_autocmd(filetype, desc)
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		pattern = filetype,
		callback = function()
			-- try_lint without arguments runs the linters defined in `linters_by_ft`
			-- for the current filetype
			require("lint").try_lint()

			-- You can call `try_lint` with a linter name or a list of names to always
			-- run specific linters, independent of the `linters_by_ft` configuration
		end,
		desc = desc,
	})
end
local c_files = { "cpp", "c", "h", "hpp", "cc", "hh", "cc", "cxx", "c++" }
for _, value in ipairs(c_files) do
	make_lint_autocmd("*." .. value, "Lint C/C++ buffer after writing")
end
