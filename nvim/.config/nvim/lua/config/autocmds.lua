-- treesitter start
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- edit 打开文件回到上次编辑位置
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local row = vim.fn.line([['"]])
    if row > 1 and row <= vim.fn.line("$") then
      vim.cmd("normal! g'\"")
    end
  end,
})

-- diagnostics hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focus = false,
      border = "rounded",
      source = "always",
    })
  end,
})

