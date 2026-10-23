return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "bashls", "clangd", "rust_analyzer", "texlab", "ts_ls", "html", "cssls" },
			automatic_enable = {
				exclude = { "stylua" },
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		event = "VimEnter",
		opts = {
			ensure_installed = { "stylua", "shfmt", "ruff", "prettier" },
			integrations = {
				["mason-lspconfig"] = false,
				["mason-null-ls"] = false,
				["mason-nvim-dap"] = false,
			},
		},
	},
}
