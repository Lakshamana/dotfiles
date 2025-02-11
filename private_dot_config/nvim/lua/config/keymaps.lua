-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.api.nvim_set_keymap("n", "zl", "32zl", { noremap = true })
vim.api.nvim_set_keymap("n", "zh", "32zh", { noremap = true })

vim.api.nvim_set_keymap("t", "<c-q>", "<c-\\><c-n>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-l>", "\rclear<CR>", { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>o", "<cmd>AerialToggle<CR>", { desc = "Toggle Outline", noremap = true })

vim.api.nvim_set_keymap("i", "<c-c>", "<esc>", { noremap = true })
