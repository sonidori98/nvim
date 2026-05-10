-- 行番号
vim.opt.number = true

-- インデント(スペース4つ)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- カーソルをブロックに
vim.opt.guicursor = "i:block"

-- 24bitカラー有効化
vim.opt.termguicolors = true

-- クリップボードをシステムと共有
vim.opt.clipboard = "unnamedplus"

-- マウス有効化
vim.opt.mouse = "a"

-- treesitter
-- local ts_group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true })
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = ts_group,
-- 	pattern = { "cpp", "rust", "lua", "bash", "python" },
-- 	callback = function(args)
-- 		local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
-- 		if lang then
-- 			pcall(vim.treesitter.start, args.buf, lang)
-- 		end
-- 	end,
-- })
