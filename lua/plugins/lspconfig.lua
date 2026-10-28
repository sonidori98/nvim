return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		local capabilities = {
			textDocument = {
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
		}

		capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

		vim.lsp.config("*", {
			capabilities = capabilities,
		})
		vim.lsp.config("clangd", {
			cmd = { "clangd", "--query-driver=/nix/store/*/bin/gcc,/run/current-system/sw/bin/gcc" },
		})
	end,
}
