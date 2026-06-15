return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("fzf-lua").setup({})
            require("fzf-lua").register_ui_select()
        end,
        keys = {
            { "<leader>fi", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Code Action (fzf)" },
            {
                "<leader>fo",
                function()
                    vim.lsp.buf.code_action({
                        apply = true,
                        context = {
                            diagnostics = {},
                            only = { "source.organizeImports" },
                        },
                    })
                end,
                desc = "Organize Imports",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        keys = {
            { "<leader>ca", false },
        },
    },
}
