-- LSP configuration for modern profile

-- Check if cmp_nvim_lsp is available
local has_cmp_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
local capabilities = vim.lsp.protocol.make_client_capabilities()

if has_cmp_lsp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- LSP keymaps
local function setup_lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
end

-- LSP on_attach function
local function on_attach(client, bufnr)
  -- Ensure bufnr is a valid number
  if not bufnr or type(bufnr) ~= 'number' then
    vim.notify('Invalid buffer number for LSP attachment', vim.log.levels.WARN)
    return
  end
  
  setup_lsp_keymaps(bufnr)
  
  -- Skip inlay hints for now to avoid API compatibility issues
  -- They can be enabled manually if needed
  if client.server_capabilities and client.server_capabilities.inlayHintProvider then
    -- Silent - no notification needed
  end
  
  -- Disable unhelpful LSP messages like "2 fewer lines; before #1 7 seconds ago"
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
    }
  )
end

-- Mason setup
local has_mason, mason = pcall(require, 'mason')
if has_mason then
  mason.setup({
    ui = {
      border = 'rounded',
    },
  })
else
  vim.notify('Mason not available - skipping LSP setup', vim.log.levels.WARN)
  return
end

-- Skip mason-lspconfig completely to avoid automatic features
-- We'll set up LSP servers directly with lspconfig instead

-- Manual installation function for LSP servers
vim.api.nvim_create_user_command('InstallLSPServers', function()
  local servers = {
    'lua_ls',
    'ts_ls',
    'eslint',
    'html',
    'cssls',
    'jsonls',
  }
  
  for _, server in ipairs(servers) do
    vim.cmd('MasonInstall ' .. server)
  end
  
  vim.notify('LSP servers installation started. Check Mason for progress.', vim.log.levels.INFO)
end, {})

-- LSP configs
local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
if not has_lspconfig then
  vim.notify('nvim-lspconfig not found', vim.log.levels.WARN)
  return
end

-- Lua LSP
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
    },
  },
})

-- TypeScript/JavaScript LSP (using ts_ls instead of deprecated tsserver)
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

-- ESLint LSP
lspconfig.eslint.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- HTML LSP
lspconfig.html.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- CSS LSP
lspconfig.cssls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- JSON LSP
lspconfig.jsonls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    json = {
      schemas = {},
      validate = { enable = true },
    },
  },
})
