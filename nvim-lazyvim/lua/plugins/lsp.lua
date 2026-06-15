return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                marksman = {},
                gopls = {
                    settings = {
                        gopls = {
                            hints = {
                                assignVariableTypes = false,
                                compositeLiteralFields = false,
                                compositeLiteralTypes = false,
                                constantValues = false,
                                functionTypeParameters = false,
                                parameterNames = true,
                                rangeVariableTypes = false,
                            },
                        },
                    },
                },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = {
            linters_by_ft = {
                markdown = {},
            },
        },
    },
}
