return {
    "nvim-telescope/telescope.nvim",
    version = "*",
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>",          desc = "Telescope find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",           desc = "Telescope live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>",             desc = "Telescope buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",           desc = "Telescope help tags" },
        { "gd",         "<cmd>Telescope lsp_definitions<cr>",     desc = "Telescope go to definition",      mode = "n" },
        { "gr",         "<cmd>Telescope lsp_references<cr>",      desc = "Telescope go to references",      mode = "n" },
        { "gi",         "<cmd>Telescope lsp_implementations<cr>", desc = "Telescope go to implementations", mode = "n" },
        { "gy",         "<cmd>Telescope lsp_type_definitions",    desc = "Telescope go to type definition", mode = "n" },
    },
}
