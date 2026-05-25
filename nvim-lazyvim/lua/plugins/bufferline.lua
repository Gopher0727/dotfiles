return {
    {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = {
            options = {
                always_show_bufferline = true,
                -- tab_size = 20,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File",
                        separator = false,
                    },
                },
            },
        },
    },
}
