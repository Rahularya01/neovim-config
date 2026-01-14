return {
    "folke/snacks.nvim",
    priority = 1000,
    event = "VeryLazy",
    opts = {
        -- Better vim.ui.input
        input = { enabled = true },
        -- Better vim.ui.select
        picker = {
            enabled = true,
            -- Explicitly map Ctrl+j and Ctrl+k for navigation
            keys = {
                next = "<C-j>",
                prev = "<C-k>",
            },
        },
        -- Better notifications
        notifier = { enabled = true },
    },
}
