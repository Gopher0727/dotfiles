return {
    {
        "saghen/blink.cmp",
        optional = true,
        opts = function(_, opts)
            opts.sources = opts.sources or {}
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
