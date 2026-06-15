return {
    {
        "stevearc/aerial.nvim",
        optional = true,
        opts = function(_, opts)
            opts.backends = { "treesitter", "lsp", "markdown", "man" }
            opts.layout = {
                width = nil,
                max_width = { 40, 0.3 },
                min_width = { 40, 0.2 },
            }
            opts.filter_kind = false
        end,
        keys = {
            { "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Aerial (Symbols)" },
            { "<leader>cs", false },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        optional = true,
        opts = function()
            LazyVim.on_load("telescope.nvim", function()
                require("telescope").load_extension("aerial")
            end)
        end,
        keys = {
            {
                "<leader>ss",
                "<cmd>Telescope aerial<cr>",
                desc = "Goto Symbol (Aerial)",
            },
        },
    },
}

-- return {
--     { import = "lazyvim.plugins.extras.editor.aerial" },
-- }
