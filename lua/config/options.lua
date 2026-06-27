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

vim.opt.wrap = false

vim.opt.splitright = true

if vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(true, { 0 })
end

local icons = require("config.icons")
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.error_icon,
            [vim.diagnostic.severity.WARN]  = icons.warn_icon,
            [vim.diagnostic.severity.HINT]  = icons.hint_icon,
            [vim.diagnostic.severity.INFO]  = icons.info_icon,
        },
    },
    virtual_text = false
})

-- IMEを自動でオフ
local uname = vim.uv.os_uname()
local group = vim.api.nvim_create_augroup("conf-ime", {})
if uname.sysname == "Linux" then
    if os.getenv("WSL_DISTRO_NAME") ~= "" then
        vim.api.nvim_create_autocmd("InsertLeave", {
            group = group,
            command = "silent! !zenhan.exe 0",
        })
    else
        vim.api.nvim_create_autocmd("InsertLeave", {
            callback = function()
                os.execute("fcitx5-remote -c")
            end
        })
    end
end
