local M = {
	cmdline = {
		keymap = {
			preset = "none",
			["<Tab>"] = { "show_and_insert", "select_next" },
			["<S-Tab>"] = { "show_and_insert", "select_prev" },

			["<C-t>"] = { "show", "fallback" },

			["<C-n>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<Right>"] = { "select_next", "fallback" },
			["<Left>"] = { "select_prev", "fallback" },

			["<C-o>"] = { "select_and_accept" },
			["<C-e>"] = { "cancel" },
		},
		completion = { menu = { auto_show = true } },
	},

	keymap = {
		preset = "none",
		["<C-t>"] = { "show", "show_documentation", "hide_documentation" },
		-- ['<C-e>'] = { 'hide' },
		-- fallback命令将运行下一个非闪烁键盘映射(回车键的默认换行等操作需要)
		["<C-e>"] = { "hide", "fallback" },
		["<CR>"] = { "accept", "fallback" }, -- 更改成'select_and_accept'会选择第一项插入
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" }, -- 同时存在补全列表和snippet时，补全列表选择优先级更高

		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
		["<C-x>"] = { "cancel" },
		["<C-n>"] = { "snippet_forward", "select_next", "fallback" }, -- 同时存在补全列表和snippet时，snippet跳转优先级更高
		["<C-p>"] = { "snippet_backward", "select_prev", "fallback" },
		["<A-1>"] = {
			function(cmp)
				cmp.accept({ index = 1 })
			end,
		},
		["<A-2>"] = {
			function(cmp)
				cmp.accept({ index = 2 })
			end,
		},
		["<A-3>"] = {
			function(cmp)
				cmp.accept({ index = 3 })
			end,
		},
		["<A-4>"] = {
			function(cmp)
				cmp.accept({ index = 4 })
			end,
		},
		["<A-5>"] = {
			function(cmp)
				cmp.accept({ index = 5 })
			end,
		},
		["<A-6>"] = {
			function(cmp)
				cmp.accept({ index = 6 })
			end,
		},
		["<A-7>"] = {
			function(cmp)
				cmp.accept({ index = 7 })
			end,
		},
		["<A-8>"] = {
			function(cmp)
				cmp.accept({ index = 8 })
			end,
		},
		["<A-9>"] = {
			function(cmp)
				cmp.accept({ index = 9 })
			end,
		},
		["<A-0>"] = {
			function(cmp)
				cmp.accept({ index = 10 })
			end,
		},
	},
}

Safe_Require("blink.cmp").setup(M)
