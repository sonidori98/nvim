return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	opts = {
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
			cpp = { "clang-format" },
			rust = { "rustfmt" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		},
	},
}
