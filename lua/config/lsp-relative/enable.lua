vim.lsp.enable("lua_ls")
vim.lsp.enable("json_ls")
vim.lsp.enable("metals")
vim.lsp.enable("lemminx")
-- vim.lsp.enable("neocmake")
vim.lsp.enable("bash")
-- vim.lsp.enable("omnisharp")
vim.lsp.enable("pyrefly")
-- vim.lsp.enable("ty")
-- vim.lsp.enable("roslyn_ls")
-- vim.lsp.enable("gradle")
-- vim.lsp.enable("gradle-analyzer")

vim.lsp.enable("yaml")
-- vim.lsp.enable("kotlin-lsp")
-- vim.lsp.enable("kotlin-language-server")
vim.lsp.enable("gopls")
vim.lsp.enable("tsc")
-- vim.lsp.enable("spy")
-- vim.lsp.enable("groovy")
-- vim.lsp.enable("gradle-lsp")
--
--[[ vim.lsp.enable("sourcekit") ]]
--
vim.lsp.enable("zls")
vim.lsp.enable("dart")
vim.lsp.enable("qmlls")

-- toml
require("config.lsp-relative.enable.toml")
require("config.lsp-relative.enable.cmake")
require("config.lsp-relative.enable.cpp")
require("config.lsp-relative.enable.markdown")
