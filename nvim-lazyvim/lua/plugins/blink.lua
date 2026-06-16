return {
    {
        "saghen/blink.cmp",
        optional = true,
        opts = function(_, opts)
            opts.completion = opts.completion or {}
            opts.completion.list = opts.completion.list or {}
            opts.completion.list.selection = {
                preselect = false,
                auto_insert = true,
            }

            opts.keymap = {
                preset = "enter",
                ["<Tab>"] = {
                    "snippet_forward",
                    function()
                        local ok, suggestion = pcall(require, "supermaven-nvim.completion_preview")
                        if ok and suggestion.has_suggestion() and not require("blink.cmp").is_visible() then
                            vim.schedule(function()
                                suggestion.on_accept_suggestion()
                            end)
                            return true
                        end
                    end,
                    "select_next",
                    "fallback",
                },
                ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
                ["<Esc>"] = { "cancel", "fallback" },
            }

            opts.sources = opts.sources or {}
            opts.sources.default = { "lsp", "path", "snippets" }
            opts.sources.providers = opts.sources.providers or {}

            -- snippets
            local snippets = opts.sources.providers.snippets or {}
            snippets.opts = snippets.opts or {}
            snippets.opts.search_paths =
                vim.list_extend({ vim.fn.stdpath("config") .. "/lua/snippets/" }, snippets.opts.search_paths or {})
            snippets.score_offset = 100
            opts.sources.providers.snippets = snippets
        end,
    },
}
