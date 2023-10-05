-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmd.lua
-- Add any additional autocmds hereby

local autosave_grp = vim.api.nvim_create_augroup("Autosave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost" }, {
  command = "silent! write",
  group = autosave_grp,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "mysql,sql,plsql",
  callback = function()
    require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
  end,
})
