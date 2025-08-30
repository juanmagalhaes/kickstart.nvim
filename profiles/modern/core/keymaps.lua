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

-- File search keymaps (exactly as in legacy)
local function setup_file_search_keymaps()
  local has_telescope, telescope = pcall(require, 'telescope.builtin')
  
  if has_telescope then
    local function fuzzyFindFiles()
      telescope.grep_string({
        path_display = { 'smart' },
        only_sort_text = true,
        word_match = "-w",
        search = '',
      })
    end

    vim.keymap.set('n', '<C-p>', telescope.git_files, { desc = 'Search [G]it [F]iles' })
    vim.keymap.set('n', 'K', telescope.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<C-a>', fuzzyFindFiles, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<C-s>', telescope.live_grep, { desc = '[S]earch Live Exact Match' })
    vim.keymap.set('n', '<leader>sh', telescope.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<C-f>', telescope.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sd', telescope.diagnostics, { desc = '[S]earch [D]iagnostics' })
    
    vim.notify('Telescope loaded successfully - all file search keybindings active', vim.log.levels.INFO)
  else
    -- Fallback keymaps when telescope is not available (exactly as in legacy)
    vim.keymap.set('n', '<C-p>', ':find ', { desc = 'Find file' })
    vim.keymap.set('n', '<C-f>', ':find ', { desc = 'Find file' })
    vim.keymap.set('n', 'K', '*', { desc = 'Search current word' })
    vim.notify('Telescope not available - using fallback keybindings (this is normal during testing)', vim.log.levels.INFO)
  end
end

-- Project tree keybinding (matching legacy profile)
vim.keymap.set('n', '<leader><space>', ':NvimTreeToggle<CR>', { desc = 'Toggle File Tree' })

-- Setup file search keymaps after a short delay to ensure plugins are loaded
vim.defer_fn(function()
  setup_file_search_keymaps()
end, 100)
