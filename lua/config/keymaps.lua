local keymap = vim.keymap

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
keymap.set("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Mason" })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        -- 一括で変数名や関数名を変更
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buf = ev.buf, desc = "LSP Rename" })
        -- クイックフィックス的な
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buf = ev.buf, desc = "LSP Code Action" })
    end,
})
