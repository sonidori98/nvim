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

		-- compile_commands.jsonが無いファイルのフォールバック時、clangdは内部で
		-- コンパイラを"clang"と決め打ちする。素のclangバイナリをPATHに入れていないので
		-- (clang-toolsパッケージはclangd/clang-tidy等のみでclang本体は含まない)、
		-- システムヘッダの位置が解決できなくなる。CompileFlags.CompilerはLSP初期化
		-- オプションからは渡せず、clangd自身のYAML設定ファイル経由でしか指定できないため、
		-- ここで生成して管理する。
		do
			local clangd_config_path = vim.fn.expand("~/.config/clangd/config.yaml")
			vim.fn.mkdir(vim.fn.fnamemodify(clangd_config_path, ":h"), "p")
			vim.fn.writefile({ "CompileFlags:", "  Compiler: gcc" }, clangd_config_path)
		end

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

		-- rust-analyzerの起動直後インデックス完了前にinlay hintを取ってしまい、
		-- 以後ファイルを編集するまでヒントが更新されない問題への対処
		vim.lsp.config("rust_analyzer", {
			capabilities = {
				experimental = {
					serverStatusNotification = true,
				},
			},
			handlers = {
				["experimental/serverStatus"] = function(_, result, ctx)
					if not result.quiescent then
						return
					end
					local client = vim.lsp.get_client_by_id(ctx.client_id)
					if not client then
						return
					end
					for bufnr in pairs(client.attached_buffers) do
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end,
			},
		})

		-- masonで入れていない(Nixで入れている)サーバー
		vim.lsp.enable({ "clangd", "nixd" })
	end,
}
