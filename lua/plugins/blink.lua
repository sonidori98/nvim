return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"alexandre-abrioux/blink-cmp-npm.nvim",
	},
	opts = {
		keymap = { preset = "super-tab" },
		sources = {
			default = function()
				local row, col = unpack(vim.api.nvim_win_get_cursor(0))
				local ok, node = pcall(vim.treesitter.get_node, { pos = { row - 1, math.max(col - 1, 0) } })
				if ok and node and node:type():find("comment") then
					return { "buffer", "dictionary" }
				end
				return { "lazydev", "snippets", "lsp", "path", "buffer" }
			end,
			per_filetype = {
				markdown = { "snippets", "lsp", "path", "dictionary" },
				text = { "buffer", "dictionary" },
				gitcommit = { "buffer", "dictionary" },
				json = { "lazydev", "snippets", "lsp", "path", "buffer", "npm" },
			},
			providers = {
				npm = {
					name = "npm",
					module = "blink-cmp-npm",
					async = true,
				},
				dictionary = {
					module = "blink-cmp-dictionary",
					name = "Dict",
					min_keyword_length = 3,
					opts = {
						dictionary_files = function()
							local wordlist = vim.env.WORDLIST
							if wordlist and vim.uv.fs_stat(wordlist) then
								return { wordlist }
							end
							return {}
						end,
					},
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
				},
			},
		},
		snippets = { preset = "default" },
		completion = {
			menu = {
				auto_show = function(ctx)
					return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
				end,
			},
			-- 候補を選ぶとドキュメントも横に出す
			documentation = { auto_show = true },
		},
		-- 関数の引数を入力中にシグネチャを出す
		signature = { enabled = true },
	},
}
