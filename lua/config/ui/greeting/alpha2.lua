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
	dashboard.button("p", "󰘐 Project", ":lua Snacks.picker.projects()<cr>)"),
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("r", "↺  Recently used files", ":lua Snacks.picker.recent()<cr>"),
	dashboard.button("t", "󱘣  Find text", ":lua Snacks.picker.grep()<cr>"),
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua<CR>"),
	dashboard.button("q", " Quit Neovim", ":qa<CR>"),
	dashboard.button("m", "󰍳 mason", "<cmd>Mason<cr>"),
	dashboard.button("h", "󱪙 help doc", ":lua Snacks.picker.help()<cr>"),
}

local function footer()
	local str = os.capture("fortune", true)
	return str
end
function os.capture(cmd, raw)
	local f = assert(io.popen(cmd, "r"))
	local s = assert(f:read("*a"))
	f:close()
	if raw then
		return s
	end
	s = string.gsub(s, "^%s+", "")
	s = string.gsub(s, "%s+$", "")
	s = string.gsub(s, "[\n\r]+", " ")
	return s
end
dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
