return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "saghen/blink.cmp",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local capabilities = {
            textDocument = {
                foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                },
            },
        }

        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        local mason_lspconfig = require("mason-lspconfig")

        for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
            vim.lsp.enable(server_name)
        end
    end,
}
