return {
	"saghen/blink.cmp",
	version = "*",
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
			},
			providers = {
				dictionary = {
					module = "blink-cmp-dictionary",
					name = "Dict",
					min_keyword_length = 3,
					opts = {
						dictionary_files = { "/usr/share/dict/words" },
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
		},
	},
}
