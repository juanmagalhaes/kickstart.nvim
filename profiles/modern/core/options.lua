-- Neovim options and settings

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable termguicolors for better colors
vim.opt.termguicolors = true

-- Disable swap files
vim.opt.swapfile = false

-- Search settings
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- Mouse support
vim.opt.mouse = 'a'

-- Clipboard
vim.opt.clipboard = 'unnamedplus'

-- Indentation
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- Undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Performance
vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Completion
vim.opt.completeopt = 'menuone,noselect'

-- UI
vim.wo.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.scrolloff = 8

-- Diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Show diagnostics on hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})
