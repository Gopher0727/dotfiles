return {
    {
        "akinsho/toggleterm.nvim",
        opts = {
            open_mapping = [[<c-\>]],
            insert_mappings = true,
            terminal_mappings = true,
            start_in_insert = true,
            persist_mode = false,
            direction = "vertical",
            shade_terminals = false,
            hidden = true,
            highlights = {
                Normal = { guibg = "NONE" },
                NormalFloat = { link = "Normal" },
                FloatBorder = { link = "Normal" },
            },
            float_opts = {
                border = "curved",
                winblend = 0,
            },
            size = function(term)
                if term.direction == "vertical" then
                    return math.floor(vim.o.columns * 0.4)
                elseif term.direction == "horizontal" then
                    return math.floor(vim.o.lines * 0.3)
                end
            end,
        },
        config = function(_, opts)
            opts.float_opts = vim.tbl_deep_extend("force", opts.float_opts or {}, {
                width = math.floor(vim.o.columns * 0.8),
                height = math.floor(vim.o.lines * 0.8),
            })
            require("toggleterm").setup(opts)
        end,
        keys = {
            { "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", silent = true },
            { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", silent = true },
            { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", silent = true },
            { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", silent = true },
            {
                "<Esc><Esc>",
                "<C-\\><C-n><cmd>ToggleTerm<cr>",
                mode = "t",
                silent = true,
            },
        },
    },
}
