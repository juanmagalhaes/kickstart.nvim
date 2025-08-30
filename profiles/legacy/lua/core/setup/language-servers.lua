local servers = {
  -- clangd = {},
  gopls = {
    go = {
      analyses = {
        unusedparams = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      gofumpt = true,
    },
  },
  -- pyright = {},
  -- rust_analyzer = {},
  eslint = {},
  ts_ls = {
    typescript = {
      settings = {
        preferences = {
          importModuleSpecifierPreference = "non-relative",
          preferTypeOnlyAutoImports = true,
        }
      }
    },
  },
  tailwindcss = {},

  prismals = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Check if neodev is available
local has_neodev, neodev = pcall(require, 'neodev')
if has_neodev then
  -- Setup neovim lua configuration
  neodev.setup()
else
  vim.notify('neodev not available - skipping Lua LSP setup', vim.log.levels.INFO)
end

-- Check if cmp_nvim_lsp is available
local has_cmp_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
local capabilities = vim.lsp.protocol.make_client_capabilities()

if has_cmp_lsp then
  -- nvim-cmp supports additional completion capabilities,
  -- so broadcast that to servers
  capabilities = cmp_lsp.default_capabilities(capabilities)
else
  vim.notify('cmp_nvim_lsp not available - using basic LSP capabilities', vim.log.levels.INFO)
end

-- Check if mason-lspconfig is available
local has_mason_lsp, mason_lspconfig = pcall(require, 'mason-lspconfig')

if has_mason_lsp then
  -- Ensure the servers above are installed
  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  local lspKeymaps = require('core.keymaps.async.language-servers')

  local on_attach = function(_, bufnr)
    lspKeymaps(bufnr)
  end

  mason_lspconfig.setup_handlers {
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      }
    end,
  }
else
  vim.notify('mason-lspconfig not available - skipping LSP server setup', vim.log.levels.INFO)
end

-- Tsserver run organize imports command
local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

-- Check if lspconfig is available
local has_lspconfig, lspconfig = pcall(require, 'lspconfig')

if has_lspconfig then
  -- Check if the async keymaps are available
  local has_async_keymaps, lspKeymaps = pcall(require, 'core.keymaps.async.language-servers')
  local has_ts_keymaps, tsserverKeymaps = pcall(require, 'core.keymaps.async.ts_ls')

  if has_async_keymaps and has_ts_keymaps then
    local tsserver_on_attach = function(_, bufnr)
      lspKeymaps(bufnr)

      tsserverKeymaps(bufnr, {
        organize_imports = organize_imports
      })
    end

    lspconfig.ts_ls.setup {
      on_attach = tsserver_on_attach,
      capabilities = capabilities,
      commands = {
        OrganizeImports = {
          organize_imports,
          description = "Organize Imports"
        }
      }
    }
  else
    vim.notify('Async keymaps not available - skipping TypeScript LSP setup', vim.log.levels.INFO)
  end
else
  vim.notify('lspconfig not available - skipping LSP configuration', vim.log.levels.INFO)
end
