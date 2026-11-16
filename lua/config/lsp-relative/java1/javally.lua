local success, javally = pcall(require, "javally")

if success == false then
	vim.notify(string.format("Failed to load javally! : %s", javally), vim.log.levels.ERROR)
	return
end
javally.setup()
