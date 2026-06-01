return {
    {
        "pocco81/auto-save.nvim",
        keys = {
            { "<leader>as", "<cmd>ASToggle<cr>", desc = "Toggle auto-save" },
        },
        config = function()
            require("auto-save").setup({
                trigger_events = { "InsertLeave", "TextChanged" },
                debounce_delay = 135,
                condition = function(buf)
                    local fn = vim.fn
                    local utils = require("auto-save.utils.data")
                    return not utils.not_in(fn.getbufvar(buf, "&filetype"), {
                        "TelescopePrompt",
                        "harpoon",
                    }) and fn.getbufvar(buf, "&modifiable") == 1 and not utils.is_special_buffer(
                        buf
                    ) and fn.filereadable(fn.expand("%")) == 1
                end,
            })
        end,
    },
}
