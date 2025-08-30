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

-- Notification settings for noice.nvim
vim.opt.termguicolors = true
vim.opt.showmode = false  -- Hide -- INSERT -- mode indicator (noice.nvim handles this)

-- More aggressive filtering for unhelpful LSP messages
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      -- Completely disable the message handlers that cause noise
      client.handlers['window/showMessage'] = function() return end
      client.handlers['window/logMessage'] = function() return end
      client.handlers['telemetry/event'] = function() return end
      
      -- Only keep essential handlers
      client.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
          virtual_text = true,
          signs = true,
          underline = true,
          update_in_insert = false,
        }
      )
    end
  end,
})

-- Override vim.notify to filter out unwanted messages
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  -- Convert message to lowercase for pattern matching
  local message = tostring(msg):lower()
  
  -- Block messages about line changes, positions, timestamps
  if message:match('fewer lines') or
     message:match('more lines') or
     message:match('before #%d+') or
     message:match('%d+ seconds ago') or
     message:match('already at newest change') or
     message:match('already at oldest change') or
     message:match('line %d+') or
     message:match('position') or
     message:match('updated') then
    return -- Don't show these messages
  end
  
  -- Route errors and warnings through noice.nvim (top-right floating)
  if level == vim.log.levels.ERROR or level == vim.log.levels.WARN then
    -- Try to use noice.nvim if available
    local ok, noice = pcall(require, 'noice')
    if ok and noice.notify then
      return noice.notify(msg, level, opts)
    else
      -- Fallback to original vim.notify for errors/warnings
      return original_notify(msg, level, opts)
    end
  end
  
  -- Route info and debug messages through bottom bar (less intrusive)
  if level == vim.log.levels.INFO or level == vim.log.levels.DEBUG then
    -- Only show important info messages
    if message:match('loading profile') or message:match('error') then
      return original_notify(msg, level, opts)
    end
    -- Block other info messages to reduce noise
    return
  end

  -- Default: use original vim.notify (bottom bar)
  return original_notify(msg, level, opts)
end

-- Override vim.api.nvim_err_writeln to use noice.nvim for errors
local original_err_writeln = vim.api.nvim_err_writeln
vim.api.nvim_err_writeln = function(str)
  -- Route errors through noice.nvim
  local ok, noice = pcall(require, 'noice')
  if ok and noice.notify then
    noice.notify(str, vim.log.levels.ERROR)
  else
    -- Fallback to original
    original_err_writeln(str)
  end
end

-- vim: ts=2 sts=2 sw=2 et
