return {
    "simeji/winresizer",
    keys = {
        { "<C-e>", mode = "n", desc = "Window Resizer" },
    },
    init = function()
        vim.g.winresizer_vert_resize = 1
        vim.g.winresizer_horiz_resize = 1
    end
}
