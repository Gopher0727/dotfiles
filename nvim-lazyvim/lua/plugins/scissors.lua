return {
    {
        "chrisgrieser/nvim-scissors",
        config = function()
            require("scissors").setup({
                snippetDir = vim.fn.stdpath("config") .. "/lua/snippets/",
            })
        end,
        keys = {
            {
                "<leader>se",
                function()
                    require("scissors").editSnippet()
                end,
                desc = "Snippet: Edit",
            },
            {
                "<leader>sa",
                function()
                    require("scissors").addNewSnippet()
                end,
                mode = { "n", "x" },
                desc = "Snippet: Add",
            },
        },
    },
}
