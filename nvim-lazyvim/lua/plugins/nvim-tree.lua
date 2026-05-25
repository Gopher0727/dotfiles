return {
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            filters = {
                dotfiles = false,
                custom = { "^.git$" },
            },
            view = {
                width = 35,
            },
            git = {
                enable = true,
                ignore = false,
            },
            renderer = {
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        git = true,
                    },
                },
                highlight_git = true,
            },
            update_focused_file = {
                enable = true,
                update_root = false,
            },
            hijack_directories = {
                enable = true,
                auto_open = true,
            },
        },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
            { "<leader>fe", "<cmd>NvimTreeFindFile<CR>", desc = "Find current file in tree" },
            { "<leader>fl", "<cmd>NvimTreeCollapse<CR>", desc = "Collapse tree" },
        },
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end,
    },
}
