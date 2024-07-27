local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set('n', '<F6>', function()
  vim.cmd.RustLsp 'runnables'
end, { silent = true, buffer = bufnr })
vim.keymap.set('n', '<F5>', function()
  vim.cmd.RustLsp 'debuggables'
end, { silent = true, buffer = bufnr })
