-- ==============================
--    lua/keymaps/global.lua
--      Global Keymaps
-- ==============================

-- 常用模式缩写：
-- n: normal mode (普通模式)
-- i: insert mode (插入模式)
-- v: visual mode (可视模式)
-- x: visual block mode (可视块模式)
-- t: terminal mode (终端模式)
-- c: command-line mode (命令行模式)

-- 辅助函数，简化键位映射的定义
local map = vim.keymap.set

-- 保存/退出
map("n", "<leader>q", ":q<CR>", { desc = "Quit current window", silent = true })
map("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit Neovim", silent = true })

-- 缓冲区操作
map("n", "<leader>bn", ":bnext<CR>", { desc = "Go to next buffer", silent = true })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Go to previous buffer", silent = true })
map("n", "<leader>bd", ":bdelete!<CR>", { desc = "Delete current buffer", silent = true })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height", silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height", silent = true })

-- 调整窗口水平宽度
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width", silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width", silent = true })
-- 分屏操作
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically", silent = true })
map("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally", silent = true })
map("n", "<leader>sc", "<C-W>c", { desc = "Close current split" })
map("n", "<leader>s=", "<C-W>=", { desc = "Equalize splits" })

-- 移动光标在分屏之间 (使用 Ctrl + H/J/K/L)
map("n", "<C-h>", "<C-W>h", { desc = "Focus left split" })
map("n", "<C-j>", "<C-W>j", { desc = "Focus lower split" })
map("n", "<C-k>", "<C-W>k", { desc = "Focus upper split" })
map("n", "<C-l>", "<C-W>l", { desc = "Focus right split" })
map("c", "<C-c>", "<Esc>", { desc = "Exit command-line mode", silent = true })

-- 插入模式下的 jk 退出

map("t", "<A-;>", "<cmd>stopinsert<CR>", { desc = "Exit terminal mode", silent = true })
-- map("t", "jk", "<cmd>stopinsert<CR>", { desc = "Exit Insert Mode", silent = true })
-- Visual 模式下缩进选区
map("v", ">", ">gv", { desc = "Indent selection" })
map("v", "<", "<gv", { desc = "Outdent selection" })
map({ "n", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file", silent = true })

-- Normal 和 Visual 模式下，J 合并下一行
map({ "n", "v" }, "J", "mzJ`z", { desc = "Join lines" })

-- 保持高亮搜索结果，在输入后立即清除
map("n", "<leader>uh", ":nohlsearch<CR>", { desc = "Clear search highlighting", silent = true })

-- 复制文件路径到系统剪贴板
map("n", "<leader>fP", ":let @+ = expand('%:p')<CR>", { desc = "Copy full file path", silent = true })
map("n", "<leader>fd", ":let @+ = expand('%:p:h')<CR>", { desc = "Copy directory path", silent = true })
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
