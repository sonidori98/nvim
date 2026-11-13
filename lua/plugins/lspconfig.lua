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

		local function get_python_path(root_dir)
			if vim.env.VIRTUAL_ENV then
				return vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
			end
			local venv = vim.fs.joinpath(root_dir, ".venv", "bin", "python")
			if vim.uv.fs_stat(venv) then
				return venv
			end
			return vim.fn.exepath("python3")
		end

		vim.lsp.config("basedpyright", {
			before_init = function(_, config)
				config.settings = config.settings or {}
				config.settings.python = config.settings.python or {}
				config.settings.python.pythonPath = get_python_path(config.root_dir)
			end,
		})

		-- masonで入れていない(Nixで入れている)サーバー
		vim.lsp.enable({ "clangd", "nixd" })
	end,
}
