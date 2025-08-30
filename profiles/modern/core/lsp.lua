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
  setup_lsp_keymaps(bufnr)
  
  -- Enable inlay hints if supported
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end
end

-- Mason setup
local has_mason, mason = pcall(require, 'mason')
if has_mason then
  mason.setup({
    ui = {
      border = 'rounded',
    },
  })
end

-- Mason LSP config
local has_mason_lsp, mason_lsp = pcall(require, 'mason-lspconfig')
if has_mason_lsp then
  mason_lsp.setup({
    ensure_installed = {
      'lua_ls',
      'tsserver',
      'eslint',
      'html',
      'cssls',
      'jsonls',
    },
    automatic_installation = true,
  })
end

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

-- TypeScript/JavaScript LSP
lspconfig.tsserver.setup({
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
