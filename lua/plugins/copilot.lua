return {
    "zbirenbaum/copilot.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        suggestion = {
            auto_trigger = true,
        },
    },
}
