-- Autocommands for modern profile

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.lua', '*.js', '*.ts', '*.jsx', '*.tsx', '*.py', '*.go', '*.rs' },
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
})

-- Auto-format on save for certain file types
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.lua', '*.js', '*.ts', '*.jsx', '*.tsx', '*.json' },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Set filetype for certain extensions
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.conf', '*.config' },
  command = 'set filetype=conf',
})

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown', 'text' },
  command = 'setlocal spell spelllang=en_us',
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd('VimResized', {
  command = 'wincmd =',
})

-- Remember cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
