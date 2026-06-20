return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                marksman = {},
                clangd = {
                    cmd = {
                        "clangd",
                        "--header-insertion=never",
                        "--log=verbose",
                        "--pretty",
                        "--completion-style=detailed",
                        "--function-arg-placeholders=false",
                        "--pch-storage=memory",
                    },
                },
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
