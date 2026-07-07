return {
    {
        "sonidori98/parsee.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("parsee")
        end
    },

    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = {}
    },
}
