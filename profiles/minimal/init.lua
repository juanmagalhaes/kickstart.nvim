-- Minimal Neovim Configuration Profile
-- Lightweight setup for quick editing

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Basic keymaps
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>e', ':e<CR>', { desc = 'Edit file' })

-- Simple file finder
vim.keymap.set('n', '<leader>f', ':find ', { desc = 'Find file' })

-- vim: ts=2 sts=2 sw=2 et
