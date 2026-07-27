local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {

	[[ █████╗ ██╗     ██╗ ██████╗ ██████╗ ██████╗]],
	[[██╔══██╗██║    ███║██╔═████╗╚════██╗╚════██]],
	[[███████║██║    ╚██║██║██╔██║ █████╔╝ █████╔]],
	[[██╔══██║██║     ██║████╔╝██║ ╚═══██╗ ╚═══██]],
	[[██║  ██║███████╗██║╚██████╔╝██████╔╝██████╔]],
	[[╚═╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ╚═════╝ ╚═════╝]],
}

dashboard.section.buttons.val = {
	dashboard.button("f", "📁 Find file", ":lua Snacks.picker.smart()<cr>"),
	dashboard.button("p", "󰘐 Project", ":lua Snacks.picker.projects()<cr>"),
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("r", "↺  Recently used files", ":lua Snacks.picker.recent()<cr>"),
	dashboard.button("t", "󱘣  Find text", ":lua Snacks.picker.grep()<cr>"),
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua<CR>"),
	dashboard.button("q", " Quit Neovim", ":qa<CR>"),
	dashboard.button("m", "󰍳 mason", "<cmd>Mason<cr>"),
	dashboard.button("h", "󱪙 help doc", ":lua Snacks.picker.help()<cr>"),
}

local function load_footer()
	vim.system({ "fortune" }, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				vim.notify(
					"Failed to load dashboard footer: " .. (result.stderr or "unknown error"),
					vim.log.levels.WARN
				)
				return
			end

			dashboard.section.footer.val = vim.trim(result.stdout or "")
			alpha.redraw()
		end)
	end)
end

dashboard.section.footer.val = ""

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
load_footer()
