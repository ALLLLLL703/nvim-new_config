vim.api.nvim_create_autocmd('FileType', {
  pattern = { '*.*' },
  callback = function() vim.treesitter.start() end,
})
