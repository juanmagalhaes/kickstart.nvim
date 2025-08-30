-- Global settings for modern profile

-- Folding settings (start with no folding)
vim.opt.foldlevel = 999  -- No folding by default (everything visible)
vim.opt.foldlevelstart = 999  -- Start with no folding
vim.opt.foldenable = true
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- Prevent auto-folding while typing
vim.opt.foldopen = 'block,hor,insert,jump,mark,percent,quickfix,search,tag,undo'

-- Better fold behavior
vim.opt.foldminlines = 1
vim.opt.foldnestmax = 3

-- Disable auto-fold on buffer changes
vim.opt.foldcolumn = '0'

-- vim: ts=2 sts=2 sw=2 et
