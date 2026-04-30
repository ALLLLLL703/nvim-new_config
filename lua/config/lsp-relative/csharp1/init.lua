local snacks = require("snacks")
local omni_extended = require("omnisharp_extended")

-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	pattern = "*.cs",
-- 	callback = function(args)
-- 		if args.file:match("^.+(%..+)$") == "cs" then
-- 		end
-- 		vim.keymap.set("n", "gd", omni_extended.telescope_lsp_definitions, { buf = args.buf })
-- 		vim.keymap.set("n", "gr", omni_extended.telescope_lsp_references, { buf = args.buf })
-- 		vim.keymap.set("n", "gi", omni_extended.telescope_lsp_implementation, { buf = args.buf })
-- 	end,
-- })
