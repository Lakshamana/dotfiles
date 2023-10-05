-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.api.nvim_set_keymap('n', 'zl', '32zl', { noremap = true })
vim.api.nvim_set_keymap('n', 'zh', '32zh', { noremap = true })

vim.api.nvim_set_keymap('t', '<c-q>', '<c-\\><c-n>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<c-l>', '\rclear<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>o', ':Telescope lsp_document_symbols<CR>', { noremap = true  })

vim.api.nvim_set_keymap('n', '<Leader>gf', ':diffget //2<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>gj', ':diffget //3<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>gs', ':Git<CR>', { noremap = false })
vim.api.nvim_set_keymap('n', '<Leader>gc', ':Git commit -v -q<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>ga', ':Gcommit --amend<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>gt', ':Gcommit -v -q %<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>gd', ':Gdiff<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>gvd', ':Gvdiffsplit!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>gl', ':silent! Git log<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>gp', ':Ggrep<Space>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>gm', ':Git merge<Space>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>gb', ':Git branch<Space>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>go', ':Telescope git_branches<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>gps', ':Git push<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>gpl', ':Git pull<CR>', { noremap = true })
