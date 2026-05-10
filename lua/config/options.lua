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

-- 不要な標準プラグインを無効化
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
}

for _, plugin in ipairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

-- tree-sitter
local ts_group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = ts_group,
    pattern = { "cpp", "rust", "lua", "bash", "python", "c" },
    callback = function(args)
        local bufnr = args.buf
        local ft = vim.bo[bufnr].filetype
        local lang = vim.treesitter.language.get_lang(ft) or ft

        local has_parser, _ = pcall(vim.treesitter.language.add, lang)
        if has_parser then
            vim.treesitter.start(bufnr, lang)
        end
    end,
})
