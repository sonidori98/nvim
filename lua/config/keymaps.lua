local keymap = vim.keymap

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
keymap.set("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Mason" })

keymap.set("", "<F1>", "<nop>")

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        -- 一括で変数名や関数名を変更
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buf = ev.buf, desc = "LSP Rename" })
        -- クイックフィックス的な
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buf = ev.buf, desc = "LSP Code Action" })
    end,
})


local colorschemes = {
    { theme = "parsee",          plugin = "parsee.nvim" },
    { theme = "tokyonight-moon", plugin = "tokyonight.nvim" },
}
local current_idx = 1

keymap.set("n", "<Leader>tc", function()
    current_idx = current_idx + 1
    if current_idx > #colorschemes then
        current_idx = 1
    end

    local target = colorschemes[current_idx]
    local theme = target.theme
    local plugin = target.plugin

    local has_lazy, lazy = pcall(require, "lazy")
    if has_lazy and plugin then
        lazy.load({ plugins = { plugin } })
    end

    local success, _ = pcall(function()
        vim.cmd.colorscheme(theme)
    end)

    if success then
        print("Colorscheme: " .. theme)
    else
        print("Failed to change colorscheme: " .. theme)
    end
end, { desc = "Toggle Colorscheme" })
