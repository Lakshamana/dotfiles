-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmd.lua
-- Add any additional autocmds hereby

local autosave_grp = vim.api.nvim_create_augroup("Autosave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost" }, {
  command = "silent! write",
  group = autosave_grp,
})

local cmp = require("cmp") -- must have this

local autocomplete_group = vim.api.nvim_create_augroup("vimrc_autocompletion", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    cmp.setup.buffer({
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
        { name = "vsnip" },
      },
    })
  end,
  group = autocomplete_group,
})

