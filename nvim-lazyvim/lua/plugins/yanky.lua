return {
    {
        "gbprod/yanky.nvim",
        config = function()
            local function paste_from_unnamed()
                local lines = vim.split(vim.fn.getreg(""), "\n", { plain = true })
                return { #lines > 0 and lines or { "" }, vim.fn.getregtype(""):sub(1, 1) }
            end

            vim.g.clipboard = {
                name = "OSC 52",
                copy = {
                    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
                    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
                },
                paste = {
                    ["+"] = paste_from_unnamed,
                    ["*"] = paste_from_unnamed,
                },
            }

            vim.api.nvim_create_autocmd("TextYankPost", {
                callback = function()
                    local ev = vim.v.event
                    if ev.operator == "y" and ev.regname == "" then
                        vim.fn.setreg("+", ev.regcontents, ev.regtype)
                    end
                end,
            })

            require("yanky").setup({ system_clipboard = { sync_with_ring = false } })
        end,
    },
}
