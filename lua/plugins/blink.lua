return {
    "saghen/blink.cmp",
    version = "*",
    opts = {
        keymap = { preset = "super-tab" },
        sources = {
            default = { "lazydev", "snippets", "lsp", "path", "buffer" },
            per_filetype = {
                markdown = { "snippets", "lsp", "path" },
            },
            providers = {
                dictionary = {
                    module = "blink-cmp-dictionary",
                    name = "Dict",
                },
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                },
            },
        },
        snippets = { preset = "default" },
        completion = {
            menu = {
                auto_show = function(ctx)
                    return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
                end,
            },
        },
    },
}
