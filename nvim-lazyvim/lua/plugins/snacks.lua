return {
    {
        "akinsho/bufferline.nvim",
        enabled = false,
    },
    {
        "folke/snacks.nvim",
        optional = true,
        opts = {
            explorer = { enabled = false },
            picker = { enabled = false },
            terminal = {
                enabled = true,
                win = { height = 0.5 },
            },
        },
    },
}
