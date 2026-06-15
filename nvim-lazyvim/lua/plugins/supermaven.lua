return {
    {
        "supermaven-inc/supermaven-nvim",
        event = "InsertEnter",
        opts = {
            disable_inline_completion = false,
            keymaps = {
                accept_suggestion = nil,
                clear_suggestion = nil,
                accept_word = nil,
            },
        },
    },
    {
        "saghen/blink.cmp",
        optional = true,
        opts = function(_, opts)
            opts.keymap = opts.keymap or {}
            opts.keymap["<S-Tab>"] = {
                function()
                    local ok, suggestion = pcall(require, "supermaven-nvim.completion_preview")
                    if ok and suggestion.has_suggestion() then
                        vim.schedule(function()
                            suggestion.on_accept_suggestion()
                        end)
                        return true
                    end
                end,
                "select_prev",
            }
        end,
    },
}
