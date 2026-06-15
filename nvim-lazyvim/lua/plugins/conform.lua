return {
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
                rust = { "rustfmt" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                php = { "php_cs_fixer" },
                kotlin = { "ktlint" },
                markdown = { "prettier" },
                tex = { "latexindent" },
                json = { "jq" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                cmake = { "cmake_format" },
                toml = { "taplo" },
                ["_"] = { "trim_whitespace" },
            },
        },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = "n",
                desc = "Format file",
            },
        },
    },
}
