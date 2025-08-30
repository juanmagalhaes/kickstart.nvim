-- Keymaps for modern profile

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- General keymaps
map({ 'n', 'v' }, '<Space>', '<Nop>')

-- Word wrap navigation
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Split resize with arrow keys
map('n', '<M-j>', ':resize +2<CR>')
map('n', '<M-k>', ':resize -2<CR>')
map('n', '<M-l>', ':vertical resize -2<CR>')
map('n', '<M-h>', ':vertical resize +2<CR>')

-- Stop yanking on paste
map('x', 'p', 'P')

-- Clear search highlights
local function nohClear()
  vim.cmd.noh()
  vim.notify("")
end

map("n", "<Esc>", nohClear)
map("n", "<C-L>", nohClear)

-- JSDoc generation
map("n", "<Leader>nf", ":lua require('neogen').generate({ type = 'func' })<CR>")

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- LSP keymaps (will be set up in lsp.lua)
local function setup_lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Go to definition
  map('n', 'gd', vim.lsp.buf.definition, opts)
  
  -- Go to declaration
  map('n', 'gD', vim.lsp.buf.declaration, opts)
  
  -- Go to implementation
  map('n', 'gi', vim.lsp.buf.implementation, opts)
  
  -- Go to references
  map('n', 'gr', vim.lsp.buf.references, opts)
  
  -- Show hover
  map('n', 'K', vim.lsp.buf.hover, opts)
  
  -- Show signature help
  map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  
  -- Code actions
  map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  
  -- Rename
  map('n', '<leader>rn', vim.lsp.buf.rename, opts)
  
  -- Format
  map('n', '<leader>f', vim.lsp.buf.format, opts)
end

-- Make setup_lsp_keymaps available globally for other modules
_G.setup_lsp_keymaps = setup_lsp_keymaps
