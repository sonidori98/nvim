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
				if require("config.declaration").is_prose() then
					return { "buffer", "dictionary" }
				end
				return { "lazydev", "snippets", "lsp", "path", "buffer", "dictionary" }
			end,
			per_filetype = {
				markdown = { "snippets", "lsp", "path", "buffer", "dictionary" },
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
					score_offset = function()
						local decl = require("config.declaration")
						if decl.is_prose() then
							return 0
						end
						return decl.is_declaring() and 10 or -5
					end,
					enabled = function()
						return not require("config.declaration").is_member_access()
					end,
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
			documentation = { auto_show = true },
		},
		signature = { enabled = true },
	},
}
