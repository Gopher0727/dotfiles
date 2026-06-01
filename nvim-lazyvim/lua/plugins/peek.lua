return {
    {
        "toppair/peek.nvim",
        lazy = false,
        build = "deno task --quiet build:fast",
        keys = {
            { "<leader>mp", "<cmd>PeekOpen<cr>", desc = "Markdown preview" },
            { "<leader>mP", "<cmd>PeekClose<cr>", desc = "Close markdown preview" },
        },
        config = function()
            require("peek").setup({
                auto_load = true,
                close_on_bdelete = true,
                syntax = true,
                theme = "dark",
                update_on_change = true,
                throttle = "auto",
            })
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },
}
