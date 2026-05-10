return {
    "FotiadisM/tabset.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        defaults = {
            tabwidth = 4,
            expandtab = true,
        },
        languages = {
            {
                filetypes = { "c", "cpp" },
                config = {
                    tabwidth = 2,
                    expandtab = true,
                }
            },
        },
    },
}
